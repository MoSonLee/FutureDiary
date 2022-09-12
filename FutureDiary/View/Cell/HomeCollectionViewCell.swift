//
//  HomeCollectionViewCell.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static var identifider: String {
        return "HomeCollectionViewCell"
    }
    
    var currentTitleTextLabel = UILabel()
    var currentTextView = UITextView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        [currentTitleTextLabel, currentTextView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        currentTextView.isEditable = false
        currentTextView.isUserInteractionEnabled = false
        currentTitleTextLabel.insetsLayoutMarginsFromSafeArea = true
        setComponentsColor()
    }
    
    private func setComponentsColor() {
        contentView.backgroundColor = CustomColor.shared.textColor
        currentTitleTextLabel.backgroundColor = CustomColor.shared.backgroundColor
        currentTextView.backgroundColor = CustomColor.shared.backgroundColor
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currentTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            currentTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            currentTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            currentTitleTextLabel.bottomAnchor.constraint(equalTo: currentTextView.topAnchor, constant: -1),
            
            currentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            currentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            currentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
}
