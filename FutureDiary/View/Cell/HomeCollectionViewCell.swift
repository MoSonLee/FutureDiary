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
    }
    
    private func setConstraints() {
        
    }
}
