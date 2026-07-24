//
//  SettingsView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import StoreKit
import UIKit

private struct SettingsItem {
    let title: String
    let symbolName: String
    let tintColor: UIColor
    let action: SettingsAction
}

private enum SettingsAction {
    case shareApp
    case help
    case rateApp
    case openURL(String)
}

private enum SettingsSection: Int, CaseIterable {
    case support
    case moreApps

    var title: String {
        switch self {
        case .support:
            return "Support"
        case .moreApps:
            return "More Apps"
        }
    }
}

final class SettingsView: UITableViewController {
    private lazy var viewModel: SettingsViewModelProtocol = SettingsViewModel()

    private let supportItems: [SettingsItem] = [
        SettingsItem(title: "Share the App", symbolName: "square.and.arrow.up", tintColor: .systemBlue, action: .shareApp),
        SettingsItem(title: "Help", symbolName: "questionmark.circle.fill", tintColor: .systemOrange, action: .help),
        SettingsItem(title: "Rate Us", symbolName: "star.fill", tintColor: .systemYellow, action: .rateApp)
    ]

    private let moreAppItems: [SettingsItem] = [
        SettingsItem(
            title: "Game Listing App",
            symbolName: "gamecontroller.fill",
            tintColor: .systemBlue,
            action: .openURL("https://github.com/SonmezYigithan/GameListingApp-iOS")
        ),
        SettingsItem(
            title: "Shopping App",
            symbolName: "cart.fill",
            tintColor: .systemGreen,
            action: .openURL("https://github.com/SonmezYigithan/ShoppingApp-iOS")
        ),
        SettingsItem(
            title: "Pomodoro App",
            symbolName: "timer",
            tintColor: .systemRed,
            action: .openURL("https://github.com/SonmezYigithan/PomodoroMenuBarApp-MacOS")
        )
    ]

    init() {
        super.init(style: .insetGrouped)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }

    private func prepareView() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        view.backgroundColor = .systemGroupedBackground
        tableView.backgroundColor = .systemGroupedBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
}

extension SettingsView {
    override func numberOfSections(in tableView: UITableView) -> Int {
        SettingsSection.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items(for: section).count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        SettingsSection(rawValue: section)?.title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        let item = items(for: indexPath.section)[indexPath.row]

        var configuration = UIListContentConfiguration.cell()
        configuration.text = item.title
        configuration.textProperties.font = .preferredFont(forTextStyle: .body)
        configuration.image = UIImage(systemName: item.symbolName)
        configuration.imageProperties.tintColor = item.tintColor
        configuration.imageProperties.preferredSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular)
        configuration.imageToTextPadding = 12

        cell.contentConfiguration = configuration
        cell.accessoryType = item.usesDisclosureIndicator ? .disclosureIndicator : .none
        cell.selectionStyle = .default
        cell.backgroundColor = .secondarySystemGroupedBackground

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handle(items(for: indexPath.section)[indexPath.row].action)
    }

    private func items(for section: Int) -> [SettingsItem] {
        switch SettingsSection(rawValue: section) {
        case .support:
            return supportItems
        case .moreApps:
            return moreAppItems
        case .none:
            return []
        }
    }

    private func handle(_ action: SettingsAction) {
        switch action {
        case .shareApp:
            shareApp()
        case .help:
            showHelp()
        case .rateApp:
            requestReview()
        case .openURL(let link):
            viewModel.clickedMoreAppsLink(link: link)
        }
    }

    private func shareApp() {
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? "AIChatApp"
        let activityViewController = UIActivityViewController(
            activityItems: ["Check out \(appName)!"],
            applicationActivities: nil
        )
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.popoverPresentationController?.sourceRect = CGRect(
            x: view.bounds.midX,
            y: view.bounds.midY,
            width: 0,
            height: 0
        )

        present(activityViewController, animated: true)
    }

    private func showHelp() {
        let alertController = UIAlertController(
            title: "Help",
            message: "For support, please contact the developer from the app's project page.",
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }

    private func requestReview() {
        guard let scene = view.window?.windowScene else {
            return
        }

        SKStoreReviewController.requestReview(in: scene)
    }
}

private extension SettingsItem {
    var usesDisclosureIndicator: Bool {
        if case .openURL = action {
            return true
        }

        return false
    }
}

private extension UITableViewCell {
    static var reuseIdentifier: String {
        String(describing: UITableViewCell.self)
    }
}
