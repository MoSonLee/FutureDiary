//
//  UIViewController+Extension.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/17.
//

import UIKit

extension UIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:    #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setNavigationColor() {
        self.navigationController?.navigationBar.tintColor = CustomColor.shared.buttonTintColor
        self.navigationItem.rightBarButtonItem?.tintColor = CustomColor.shared.buttonTintColor
        self.navigationController?.navigationBar.backgroundColor = .clear
    }
    
    func setDatePicker(datePicker: UIDatePicker) {
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        datePicker.locale = Locale(identifier: Locale.current.identifier)
        datePicker.timeZone = TimeZone(abbreviation: Locale.current.identifier)
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 1, to: datePicker.date)
        datePicker.addTarget(self, action: #selector(method), for: .valueChanged)
        datePicker.tintColor = CustomColor.shared.buttonTintColor
    }
    
    func setHomeCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = (UIScreen.main.bounds.width / 3 - spacing)
            layout.itemSize = CGSize(width: width, height: width * 0.7)
            return layout
        } else {
            let width = UIScreen.main.bounds.width - spacing
            layout.itemSize = CGSize(width: width, height: width * 0.5)
            return layout
        }
    }
    
    func setCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let width = UIScreen.main.bounds.width / 3 - 16
            layout.itemSize = CGSize(width: width, height: width * 0.7 )
            layout.headerReferenceSize = CGSize(width: view.bounds.width / 3, height: 30)
            return layout
        } else {
            let width = UIScreen.main.bounds.width / 3 - 20
            layout.itemSize = CGSize(width: width, height: width * 1.1)
            layout.headerReferenceSize = CGSize(width: view.bounds.width / 3, height: 30)
            return layout
        }
    }
    
    func showAlert(title: String) {
        let alert =  UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style:.destructive, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
    
    func setCustomFont(size: CGFloat) -> UIFont? {
        let font = UIFont(name: "NanumNaEuiANaeSonGeurSsi", size: size)
        return font
    }
}
