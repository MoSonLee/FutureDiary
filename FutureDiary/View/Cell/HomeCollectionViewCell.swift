//
//  HomeCollectionViewCell.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    var currentTitleTextLabel = UILabel()
    var currentTextView = UITextView()
    
    static var identifider: String {
        return "HomeCollectionViewCell"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        contentView.backgroundColor = .systemTeal
        [currentTitleTextLabel, currentTextView].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        currentTextView.isEditable = false
        currentTextView.isUserInteractionEnabled = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            currentTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            currentTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            currentTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            currentTitleTextLabel.bottomAnchor.constraint(equalTo: currentTextView.topAnchor, constant: -8),
            
            currentTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            currentTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            currentTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
