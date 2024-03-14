//
//  CameraInputViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import AVFoundation
import UIKit
import Vision

protocol CameraInputViewModelProtocol {
    func viewDidLoad()
    func didTapTakePhoto()
    func recognizeText(in image: UIImage)
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
}

protocol CameraInputDelegate: AnyObject {
    func didTextRecognitionFinish(message: String)
}

class CameraInputViewModel: NSObject {
    weak var view: CameraInputViewProtocol?
    var delegate: CameraInputDelegate?
    
    var session: AVCaptureSession?
    var output = AVCapturePhotoOutput()
    
    init(view: CameraInputViewProtocol) {
        self.view = view
    }
    
    private func checkCameraPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera()
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera()
        @unknown default:
            break
        }
    }
    
    private func setupCamera() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let session = AVCaptureSession()
            if let device = AVCaptureDevice.default(for: .video) {
                do {
                    let input = try AVCaptureDeviceInput(device: device)
                    if session.canAddInput(input) {
                        session.addInput(input)
                    }
                    
                    if session.canAddOutput(self.output) {
                        session.addOutput(self.output)
                    }
                    
                    DispatchQueue.main.async {
                        self.view?.previewLayer.videoGravity = .resizeAspectFill
                        self.view?.previewLayer.session = session
                    }
                    
                    session.startRunning()
                    self.session = session
                } catch {
                    print(error)
                }
            }
        }
    }
}

extension CameraInputViewModel: CameraInputViewModelProtocol {
    func viewDidLoad() {
        checkCameraPermissions()
    }
    
    func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    func recognizeText(in image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cgImage: cgImage, orientation: .up)
        
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let results = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }
            let message = results.compactMap {
                $0.topCandidates(1).first?.string
            }.joined(separator: "\n")
            print(message)
            DispatchQueue.main.async {
                self?.delegate?.didTextRecognitionFinish(message: message)
                self?.view?.dismissView()
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try imageRequestHandler.perform([request])
            } catch {
                DispatchQueue.main.async {
                    print("Failed to perform image request: \(error)")
                    let alert = UIAlertController(title: "Error", message: "There was a problem with text recognition pls try again", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { action in
                        self.view?.dismissView()
                    }))
                    self.view?.showAlertMessage(alert: alert)
                    return
                }
            }
        }
    }
    
    /// https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        
        
        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        
        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }
        
        
        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
    }
}

extension CameraInputViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else { return }
        if let image = UIImage(data: data) {
            view?.finishProcessingPhoto(image: image)
        }
        session?.stopRunning()
    }
}
