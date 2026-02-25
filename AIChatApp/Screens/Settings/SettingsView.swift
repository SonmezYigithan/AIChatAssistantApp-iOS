//
//  SettingsView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

struct SettingsCell {
    let name: String
    let image: UIImage?
    let link: String?
}

final class SettingsView: UIViewController {
    private lazy var viewModel: SettingsViewModelProtocol = SettingsViewModel()
    
    private var settings = [SettingsCell]()
    private var moreApps = [SettingsCell]()
    
    private let settingsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 23)
        label.text = "Settings"
        return label
    }()
    
    private let settingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 15
        tableView.isScrollEnabled = false
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return tableView
    }()
    
    private let moreAppsLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 23)
        label.text = "More Apps"
        return label
    }()
    
    private let moreAppsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customGrayText
        label.font = .systemFont(ofSize: 14)
        label.text = "Would you like to check out our other \namazing apps?"
        label.numberOfLines = 2
        return label
    }()
    
    private let moreAppsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(MoreAppsTableViewCell.self, forCellReuseIdentifier: MoreAppsTableViewCell.identifier)
        return tableView
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 25
        stack.axis = .vertical
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsTableView.layoutIfNeeded()
        settingsTableView.snp.updateConstraints { make in
            make.height.equalTo(settingsTableView.contentSize.height)
        }
        
        moreAppsTableView.layoutIfNeeded()
        moreAppsTableView.snp.updateConstraints { make in
            make.height.equalTo(moreAppsTableView.contentSize.height)
        }
    }
    
    private func prepareView() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(settingsLabel)
        stackView.addArrangedSubview(settingsTableView)
        stackView.addArrangedSubview(moreAppsLabel)
        stackView.addArrangedSubview(moreAppsDescriptionLabel)
        stackView.setCustomSpacing(15, after: moreAppsDescriptionLabel)
        stackView.addArrangedSubview(moreAppsTableView)
        
        settingsTableView.dataSource = self
        settingsTableView.delegate = self
        moreAppsTableView.dataSource = self
        moreAppsTableView.delegate = self
        
        settings = [SettingsCell(name: "Share The App", image: UIImage(systemName: "shareplay"), link: nil),
                    SettingsCell(name: "Help", image: UIImage(systemName: "questionmark"), link: nil),
                    SettingsCell(name: "Rate Us", image: UIImage(systemName: "star.fill"), link: nil),]
        
        moreApps = [SettingsCell(name: "Game Listing App", image: UIImage(systemName: "gamecontroller.fill"), link: "https://github.com/SonmezYigithan/GameListingApp-iOS"),
                    SettingsCell(name: "Shopping App", image: UIImage(systemName: "cart.fill"), link: "https://github.com/SonmezYigithan/ShoppingApp-iOS"),
                    SettingsCell(name: "Pomodoro App", image: UIImage(systemName: "timer"),link: "https://github.com/SonmezYigithan/PomodoroMenuBarApp-MacOS"),]
        
        settingsTableView.reloadData()
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(15)
            make.width.equalTo(scrollView.snp.width).inset(15)
        }
        
        settingsTableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.width.equalToSuperview()
        }
        
        moreAppsTableView.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.width.equalToSuperview()
        }
    }
}

extension SettingsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == settingsTableView {
            return settings.count
        }else {
            return moreApps.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == settingsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableViewCell.identifier, for: indexPath) as? SettingsTableViewCell else { return UITableViewCell() }
            cell.configure(name: settings[indexPath.row].name, image: settings[indexPath.row].image)
            cell.selectionStyle = .none
            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreAppsTableViewCell.identifier, for: indexPath) as? MoreAppsTableViewCell else { return UITableViewCell() }
            cell.configure(name: moreApps[indexPath.row].name, image: moreApps[indexPath.row].image)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == settingsTableView {
            return 60
        }else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == settingsTableView {
            print("Clicked at Settings: \(indexPath.row)")
        }else {
            print("Clicked at MoreApp: \(indexPath.row)")
            viewModel.clickedMoreAppsLink(link: moreApps[indexPath.row].link ?? "")
        }
    }
}
