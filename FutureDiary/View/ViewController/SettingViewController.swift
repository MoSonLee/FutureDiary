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
    private let settingList = ["백업", "복구", "문의하기", "리뷰 작성하기", "Open License", "버전 정보"]
    
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
        self.navigationItem.title = "설정"
        setNavigationColor()
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ReusableTableViewCell.self, forCellReuseIdentifier: ReusableTableViewCell.identifier)
    }
    
    func sendMail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["ronlee6235@gmail.com"])
            mail.setSubject("문의사항")
            mail.mailComposeDelegate = self
            self.present(mail, animated: true)
            
        } else {
            view.makeToast("메일을 등록해주세요")
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
            
        case .cancelled:
            view.makeToast("취소되었습니다.")
            
        case .saved:
            view.makeToast("저장되었습니다")
            
        case .sent:
            view.makeToast("전송되었습니다.")
            
        case .failed:
            view.makeToast("전송에 실패했습니다. 다시 시도해주세요")
            
        @unknown default:
            print(error?.localizedDescription ?? "ERROR")
        }
        
        controller.dismiss(animated: true)
    }
    
    private func moveToLicenseView() {
        let vc = LicenseViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func moveToVersionView() {
        let vc = VersionViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backUpFileURL = path.appendingPathComponent("Fury.zip")
        let vc = UIActivityViewController(activityItems: [backUpFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    func backupButtonClicked() {
        var urlPaths = [URL]()
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        let realmFile = path.appendingPathComponent("default.realm")
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlert(title: "벡압힐 파일이 없습니다")
            return
        }
        
        urlPaths.append(URL(string: realmFile.path)!)
        
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "Fury")
            showActivityViewController()
            print("Archive Location: \(zipFilePath)")
        } catch {
            showAlert(title: "압축을 실패했습니다.")
        }
    }
    
    func restoreButtonClicked() {
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
        cell.settingTextLabel.textColor = CustomColor.shared.textColor
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
            return moveToVersionView()
            
        default:
            print("error")
        }
    }
}

extension SettingViewController: UIDocumentPickerDelegate{
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            showAlert(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlert(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent("Fury.zip")
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                    self.showAlert(title: "복구가 완료되었습니다.")
                })
            } catch {
                showAlert(title: "압축 해제에 실패")
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let fileURL = path.appendingPathComponent("Fury.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print(unzippedFile)
                    self.showAlert(title: "복구가 완료되었습니다.")
                })
                
            } catch {
                showAlert(title: "압축 해제에 실패했습니다.")
            }
        }
    }
}
