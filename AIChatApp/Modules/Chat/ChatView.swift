//
//  ChatView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

enum ChatType {
    case textGeneration
    case imageGeneration
    case persona
}

protocol ChatViewProtocol: AnyObject {
    func displayMessages(with presentation: [ChatCellPresentation])
    func displayMessage(message: ChatCellPresentation)
    func sendButtonClicked(message: String)
}

final class ChatView: UIViewController {
    //MARK: - Properties
    var viewModel: ChatViewModelProtocol?
    private let messageBarView = MessageBarView()
    private var chatCellPresentations = [ChatCellPresentation]()
    
    var messageViewInitialYPos: CGFloat = 0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        viewModel?.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageViewInitialYPos = messageBarView.frame.origin.y
    }
    
    private func prepareView() {
        view.backgroundColor = .systemBackground
        title = "Chat"
        
        view.addSubview(tableView)
        view.addSubview(messageBarView)
        
        tableView.delegate = self
        tableView.dataSource = self
        messageBarView.chatView = self
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        setupConstraints()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow() {
        let lastCellIndexPath = IndexPath(row: chatCellPresentations.count - 1, section: 0)
        tableView.scrollToRow(at: lastCellIndexPath, at: .bottom, animated: true)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageBarView.snp.top)
        }
        
        messageBarView.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-10)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(15)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-15)
            make.height.equalTo(56)
        }
    }
}

extension ChatView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatCellPresentations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.configure(with: chatCellPresentations[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
}

extension ChatView: ChatViewProtocol {
    func displayMessage(message: ChatCellPresentation) {
        chatCellPresentations.append(message)
        tableView.beginUpdates()
        let indexPath = IndexPath(row: chatCellPresentations.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.endUpdates()

        // Scroll to the new message
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    func displayMessages(with presentations: [ChatCellPresentation]) {
        self.chatCellPresentations = presentations
        tableView.reloadData()
    }
    
    func sendButtonClicked(message: String) {
        viewModel?.sendMessage(message: message)
    }
}
