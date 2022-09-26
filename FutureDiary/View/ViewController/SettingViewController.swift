//
//  SettingViewController.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit
import MessageUI

import RealmSwift
import Toast
import Zip

final class SettingViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    private let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), style: .plain)
    private let settingList = ["settingList_backup".localized,
                               "settingList_restore".localized,
                               "settingList_contact".localized,
                               "settingList_review".localized,
                               "settingList_license".localized,
                               "settingList_copyright".localized,
                               "settingList_version".localized]
    
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
        guard let path = documentDirectoryPath() else {
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
        var urlPaths = [URL]()
        guard let path = documentDirectoryPath() else {
            showAlert(title: "documentAlertError".localized)
            return
        }
        let realmFile = path.appendingPathComponent("default.realm")
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlert(title: "cant_search_file".localized)
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        do {
            let _ = try Zip.quickZipFiles(urlPaths, fileName: "Fury")
            showActivityViewController()
        } catch {
            showAlert(title: "fail_Uncompress".localized)
        }
    }
    
    private func restoreButtonClicked() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy:  true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
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
            cell.textLabel?.text = "1.0.0"
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
            return
            
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
        guard let selectedFileURL = urls.first else {
            showAlert(title: "cant_searchfile".localized)
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlert(title: "documentAlertError".localized)
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent("Fury.zip")
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { _ in
                    
                }, fileOutputHandler: { _ in
                    self.showRestoreCompleteAlert()
                })
            } catch {
                showAlert(title: "fail_restore".localized)
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let fileURL = path.appendingPathComponent("Fury.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { _ in
                }, fileOutputHandler: { _ in
                    self.showRestoreCompleteAlert()
                })
                
            } catch {
                showAlert(title: "fail_restore".localized)
            }
        }
    }
}
