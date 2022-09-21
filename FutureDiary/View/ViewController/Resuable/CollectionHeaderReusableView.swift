//
//  CollectionHeaderReusableView.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/13.
//
//
import UIKit

final class CollectionHeaderReusableView: UICollectionReusableView {
    
    static var identifier: String {
        return "CollectionHeaderReusableView"
    }
    
    var headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfigure() {
        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 2),
            headerLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -8),
            headerLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -2),
        ])
    }
    
    private func setComponentsColor() {
        
    }
    
    func setConfigureHeader(diaryDic: [String], indexPath: IndexPath) {
        self.headerLabel.backgroundColor = .clear
        self.headerLabel.textColor = CustomColor.shared.blackAndWhite
        self.headerLabel.text = diaryDic[indexPath.section]
    }
}
