//
//  SettingViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit
import MessageUI

import Toast

final class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
    private let settingList = ["settingList_backup".localized,
                               "settingList_restore".localized,
                               "settingList_contact".localized,
                               "settingList_review".localized,
                               "settingList_license".localized,
                               "settingList_copyright".localized,
                               "settingList_version".localized]
    
    private let viewModel = SettingViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConfigure()
        setConstraints()
        setNavigation()
        setTableView()
    }
    
    private func setConfigure() {
        view.backgroundColor = CustomColor.shared.backgroundColor
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
        ])
    }
    
    private func setNavigation() {
        self.navigationItem.title = "moveToSettingButton_title".localized
        setNavigationColor()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReusableTableViewCell.self, forCellReuseIdentifier: ReusableTableViewCell.identifier)
    }
    
    private func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["ronlee6235@gmail.com"])
            mail.setSubject("Question".localized)
            mail.mailComposeDelegate = self
            self.present(mail, animated: true)
            
        } else {
            view.makeToast("register_mail".localized)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        case .cancelled:
            view.makeToast("mail_cancel".localized)
            
        case .saved:
            view.makeToast("mail_store".localized)
            
        case .sent:
            view.makeToast("mail_send".localized)
            
        case .failed:
            view.makeToast("mail_error".localized)
            
        @unknown default:
            return
        }
        controller.dismiss(animated: true)
    }
    
    private func moveToLicenseView() {
        let vc = LicenseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func movetoCopyrightView() {
        let vc = CopyrightViewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showActivityViewController() {
        guard let path = viewModel.documentDirectoryPath() else {
            showAlert(title: "documentAlertError".localized)
            return
        }
        let backUpFileURL = path.appendingPathComponent("Fury.zip")
        
        let vc = UIActivityViewController(activityItems: [backUpFileURL], applicationActivities: [])
        if UIDevice.current.userInterfaceIdiom == .pad {
            vc.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
            vc.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 300, height: 350)
            vc.popoverPresentationController?.permittedArrowDirections = [.left]
        }
        self.present(vc, animated: true)
    }
    
    private func backupButtonClicked() {
        viewModel.showBackupAlertOrActivityVC { data in
            guard let data = data else {
                showActivityViewController()
                return
            }
            showAlert(title: data)
        }
    }
    
    private func restoreButtonClicked() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
    
    private func moveToReview() {
        if let reviewURL = URL(string: "itms-apps://itunes.apple.com/app/itunes-u/id\(6443563805)?ls=1&mt=8&action=write-review"), UIApplication.shared.canOpenURL(reviewURL) {
            UIApplication.shared.open(reviewURL, options: [:], completionHandler: nil)
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableTableViewCell.identifier) as? ReusableTableViewCell else { return UITableViewCell()}
        
        cell.settingTextLabel.text = settingList[indexPath.row]
        cell.settingTextLabel.textColor = CustomColor.shared.blackAndWhite
        
        if indexPath.row == 6 {
            cell.textLabel?.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
            cell.textLabel?.textAlignment = .right
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
            
        case 0:
            return backupButtonClicked()
            
        case 1:
            return restoreButtonClicked()
            
        case 2:
            return sendMail()
            
        case 3:
            return moveToReview()
            
        case 4:
            return moveToLicenseView()
            
        case 5:
            return movetoCopyrightView()
            
        default:
            return
        }
    }
    private func showRestoreCompleteAlert() {
        let alert =  UIAlertController(title: "restore_complete_alert".localized, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "okAlert_title".localized, style:.destructive, handler: { _ in
            exit(1)
        })
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
}

extension SettingViewController: UIDocumentPickerDelegate{
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        view.makeToast("mail_cancel".localized)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        viewModel.showRestoreAlert(urls: urls) { [weak self] data in
            self?.viewModel.showRestoreAlert(urls: urls, handler: { data in
                guard let data = data else {
                    self?.showRestoreCompleteAlert()
                    return
                }
                self?.showAlert(title: data)
            })
        }
    }
}
