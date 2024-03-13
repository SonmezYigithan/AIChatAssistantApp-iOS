//
//  HistoryView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import UIKit

struct ChatHistoryCellPresentation {
    let aiName: String
    let chatSummary: String?
    let chatMessage: String?
    let createdAt: String
    let isStarred: Bool
    let image: String?
    let chatType: ChatType
}

protocol HistoryViewProtocol: AnyObject {
    func showChatHistory(with presentation: [ChatHistoryCellPresentation])
    func showChatView(vc: ChatView)
}

final class HistoryView: UIViewController {
    var chatHistoryCellPresentation = [ChatHistoryCellPresentation]()
    private lazy var viewModel: HistoryViewModelProtocol = HistoryViewModel(view: self)
    
    private let chatHistoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        viewModel.fetchAllChatHistory()
    }
    
    private func prepareView() {
        view.backgroundColor = .red
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Chat History"
        view.addSubview(chatHistoryTableView)
        
        chatHistoryTableView.delegate = self
        chatHistoryTableView.dataSource = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        chatHistoryTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HistoryView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        chatHistoryCellPresentation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HistoryTableViewCell.identifier, for: indexPath) as? HistoryTableViewCell else { return UITableViewCell() }
        cell.configure(with: chatHistoryCellPresentation[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.loadChatMessages(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, view, success) in
            self?.viewModel.deleteChat(at: indexPath.row)
            self?.chatHistoryCellPresentation.remove(at: indexPath.row)
            self?.chatHistoryTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let swipeActions = UISwipeActionsConfiguration(actions: [delete])
        return swipeActions
    }
}

extension HistoryView: HistoryViewProtocol {
    func showChatHistory(with presentation: [ChatHistoryCellPresentation]) {
        chatHistoryCellPresentation = presentation
        chatHistoryTableView.reloadData()
    }
    
    func showChatView(vc: ChatView) {
        show(vc, sender: self)
    }
}
