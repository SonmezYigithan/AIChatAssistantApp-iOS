//
//  StoreView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

final class StoreView: UIViewController {
    // MARK: - Properties
    
    private let collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: flow)
        view.register(StoreCollectionViewCell.self, forCellWithReuseIdentifier: StoreCollectionViewCell.identifier)
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.identifier)
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
    }
    
    private func prepareView() {
        title = "AI Assistants"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
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
            make.height.equalTo(100)
        }
 
        tableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.width.equalToSuperview()
        }
    }
}

extension StoreView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCollectionViewCell.identifier, for: indexPath) as? StoreCollectionViewCell else { return UICollectionViewCell() }
//        cell.backgroundColor = .customBackground
        return cell
    }
}

extension StoreView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.identifier, for: indexPath) as? StoreTableViewCell else { return UITableViewCell() }
//        cell.backgroundColor = .customBackground
        return cell
    }
}
