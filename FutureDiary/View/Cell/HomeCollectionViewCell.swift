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
        contentView.backgroundColor = .black
        currentTitleTextLabel.backgroundColor = .white
        currentTextView.backgroundColor = .white
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currentTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            currentTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            currentTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            currentTitleTextLabel.bottomAnchor.constraint(equalTo: currentTextView.topAnchor, constant: -2),
            
            currentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            currentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
            currentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
        ])
    }
}
