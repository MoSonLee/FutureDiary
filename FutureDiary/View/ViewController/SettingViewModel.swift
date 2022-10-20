//
//  SettingViewModel.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/10/20.
//

import Foundation

import RealmSwift
import Zip

class SettingViewModel {
    
    func showBackupAlertOrActivityVC(handler: (String?) -> Void)  {
        var urlPaths = [URL]()
        guard let path = documentDirectoryPath() else {
            handler("documentAlertError".localized)
            return
        }
        
        let realmFile = path.appendingPathComponent("default.realm")
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            handler("cant_search_file".localized)
            return
        }
        urlPaths.append(URL(string: realmFile.path)!)
        do {
            let _ = try Zip.quickZipFiles(urlPaths, fileName: "Fury")
            handler(nil)
        } catch {
            handler("fail_Uncompress".localized)
        }
    }
    
    func showRestoreAlert(urls: [URL],handler: @escaping (String?) -> Void) {
        guard let selectedFileURL = urls.first else {
            handler("cant_searchfile".localized)
            return
        }
        
        guard let path = documentDirectoryPath() else {
            handler("documentAlertError".localized)
            return
        }
        
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            let fileURL = path.appendingPathComponent(sandboxFileURL.lastPathComponent)
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { _ in
                    
                }, fileOutputHandler: { _ in
                    handler(nil)
                })
            } catch {
                handler("fail_restore".localized)
            }
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                let fileURL = path.appendingPathComponent(sandboxFileURL.lastPathComponent)
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { _ in
                }, fileOutputHandler: { _ in
                    handler(nil)
                })
            } catch {
                handler("fail_restore".localized)
            }
        }
    }
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
}

