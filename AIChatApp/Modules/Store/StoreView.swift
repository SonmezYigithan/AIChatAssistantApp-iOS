//
//  StoreView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

protocol StoreViewProtocol: AnyObject {
    func showCelebrities(personas: [PersonaPresenter])
    func showExperts(personas: [PersonaPresenter])
    func navigateToChatView(vc: UIViewController)
}

final class StoreView: UIViewController {
    // MARK: - Properties
    private lazy var viewModel: StoreViewModelProtocol = StoreViewModel(view: self)
    private let collectionViewHeader = StoreCollectionViewHeader()
    
    private var celebrities = [[PersonaPresenter]]()
    private var experts = [PersonaPresenter]()
    
    private let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.register(StoreCelebritiesCollectionViewCell.self, forCellWithReuseIdentifier: StoreCelebritiesCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.sectionHeaderTopPadding = 0
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
        tableView.register(StoreTableViewHeader.self, forHeaderFooterViewReuseIdentifier: StoreTableViewHeader.identifier)
        return tableView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.tintColor = .label
        spinner.style = .large
        return spinner
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        viewModel.viewDidLoad()
    }
    
    private func prepareView() {
        title = "Personas"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(collectionViewHeader)
        stackView.addArrangedSubview(collectionView)
        stackView.addArrangedSubview(tableView)
        view.addSubview(spinner)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.dataSource = self
        tableView.delegate = self
        
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutIfNeeded()
        tableView.snp.updateConstraints { make in
            make.height.equalTo(tableView.contentSize.height)
        }
    }
    
    private func applyConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
        
        spinner.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.width.equalToSuperview()
        }
        
        collectionViewHeader.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(70)
        }
    }
}

extension StoreView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return celebrities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCelebritiesCollectionViewCell.identifier, for: indexPath) as? StoreCelebritiesCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: celebrities[indexPath.row])
        cell.viewModel = viewModel
        cell.collectionViewSectionIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: self.collectionView.frame.height)
    }
}

extension StoreView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return experts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.identifier, for: indexPath) as? StoreTableViewCell else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configure(with: experts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: StoreTableViewHeader.identifier)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectExpert(at: indexPath.row)
    }
}

extension StoreView: StoreViewProtocol {
    func navigateToChatView(vc: UIViewController) {
        show(vc, sender: self)
    }
    
    func showCelebrities(personas: [PersonaPresenter]) {
        // split persona array into 3 to show only 3 elements at every section
        let splitSize = personas.count / 3
        let splitPersonas = stride(from: 0, to: personas.count, by: splitSize).map {
            Array(personas[$0 ..< min($0 + splitSize, personas.count)])
        }
        celebrities = splitPersonas
        collectionView.reloadData()
    }
    
    func showExperts(personas: [PersonaPresenter]) {
        experts = personas
        tableView.reloadData()
    }
}
