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
    var diaryTitleTextLabel = UILabel()
    var diaryTextView = UITextView()
    var diaryDateLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
        setConstraints()
    }
    
    private func setConfigure() {
        [diaryTitleTextLabel, diaryTextView, diaryDateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        diaryTextView.isEditable = false
        diaryTextView.isUserInteractionEnabled = false
        diaryTitleTextLabel.insetsLayoutMarginsFromSafeArea = true
        setComponentsColor()
    }
    
    private func setComponentsColor() {
        contentView.backgroundColor = CustomColor.shared.textColor
        diaryTitleTextLabel.backgroundColor = CustomColor.shared.backgroundColor
        diaryTextView.backgroundColor = CustomColor.shared.backgroundColor
        diaryDateLabel.backgroundColor = CustomColor.shared.backgroundColor
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            diaryTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1),
            diaryTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            diaryTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            diaryTitleTextLabel.bottomAnchor.constraint(equalTo: diaryTextView.topAnchor, constant: -1),
            diaryTitleTextLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            
            diaryTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            diaryTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            diaryTextView.bottomAnchor.constraint(equalTo: diaryDateLabel.topAnchor, constant: 4),
            
            diaryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
            diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            diaryDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1),
        ])
    }
    
     func configureCollectionViewCell(diary: Diary) {
        
        self.diaryTitleTextLabel.text = diary.diaryTitle
        self.diaryTextView.text = diary.diaryContent
        self.diaryDateLabel.text = diary.diaryDate.toShortString
        
        self.diaryTitleTextLabel.textAlignment = .center
        self.diaryDateLabel.textAlignment = .center
        
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
        self.diaryTitleTextLabel.adjustsFontSizeToFitWidth = true
        
        self.diaryTitleTextLabel.font = .systemFont(ofSize: 12)
        self.diaryTextView.font = .systemFont(ofSize: 10)
        self.diaryDateLabel.font = .systemFont(ofSize: 10)
    }
    
    func configureSearchCollectionViewCell(searchedDiary: [Diary], indexPath: IndexPath) {
        self.diaryTitleTextLabel.text = searchedDiary[indexPath.row].diaryTitle
        self.diaryTextView.text = searchedDiary[indexPath.row].diaryContent
        self.diaryDateLabel.text = searchedDiary[indexPath.row].diaryDate.toDetailString
        self.diaryDateLabel.font = .systemFont(ofSize: 10)
        self.diaryDateLabel.textAlignment = .center
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
    }
}
