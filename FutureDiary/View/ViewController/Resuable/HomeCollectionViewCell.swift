//
//  HomeCollectionViewCell.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift

final class HomeCollectionViewCell: UICollectionViewCell {
    
    static var identifider: String {
        return "HomeCollectionViewCell"
    }
    
    private var diaryTitleTextLabel = UILabel()
    private var diaryTextView = UITextView()
    private var diaryDateLabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setConfigure()
    }
    
    private func setConfigure() {
        [diaryTitleTextLabel, diaryTextView, diaryDateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        diaryTitleTextLabel.numberOfLines = 1
        diaryTextView.isEditable = false
        diaryTextView.isUserInteractionEnabled = false
        
        diaryDateLabel.adjustsFontSizeToFitWidth = true
        diaryTitleTextLabel.insetsLayoutMarginsFromSafeArea = true
        setComponentsColor()
    }
    
    private func setComponentsColor() {
        diaryTitleTextLabel.backgroundColor = .clear
        diaryTextView.backgroundColor = .clear
        diaryDateLabel.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        diaryTextView.textColor = .black
        diaryTitleTextLabel.textColor = .black
        diaryDateLabel.textColor = .black
    }
    
    private func setConstraints() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                diaryTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                diaryTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                diaryTitleTextLabel.bottomAnchor.constraint(equalTo: diaryDateLabel.topAnchor, constant: -16),
                
                diaryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
                diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
                diaryDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            ])
        } else {
            NSLayoutConstraint.activate([
                diaryTitleTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -15),
                diaryTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                diaryTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
                
                diaryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
                diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
                diaryDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            ])
        }
    }
    
    func setHomeConstraints() {
        NSLayoutConstraint.activate([
            diaryTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            diaryTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            diaryTitleTextLabel.trailingAnchor.constraint(equalTo: diaryDateLabel.leadingAnchor, constant: -12),
            diaryTitleTextLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            diaryTitleTextLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            diaryTextView.topAnchor.constraint(equalTo: diaryTitleTextLabel.bottomAnchor, constant: 8),
            diaryTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            diaryTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            diaryTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            diaryTextView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            diaryDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            diaryDateLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        ])
    }
    
    func configureCollectionViewCell(diary: Diary) {
        self.diaryTitleTextLabel.text = diary.diaryTitle
        self.diaryTextView.text = diary.diaryContent
        self.diaryDateLabel.text = diary.diaryDate.toShortString
        self.diaryTitleTextLabel.textAlignment = .center
        self.diaryDateLabel.textAlignment = .right
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.diaryDateLabel.font = setCustomFont(size: 20)
            self.diaryTitleTextLabel.font = setCustomFont(size: 25)
        } else {
            self.diaryDateLabel.font = setCustomFont(size: 15)
            self.diaryTitleTextLabel.font = setCustomFont(size: 20)
        }
        contentView.addBackground(imageName: "mailcard",  contentMode: .scaleToFill)
        setConstraints()
    }
    
    func configureSearchCollectionViewCell(searchedDiary: [Diary], indexPath: IndexPath) {
        self.diaryTitleTextLabel.text = searchedDiary[indexPath.row].diaryTitle
        self.diaryTextView.text = searchedDiary[indexPath.row].diaryContent
        self.diaryDateLabel.text = searchedDiary[indexPath.row].diaryDate.toString
        self.diaryTitleTextLabel.textAlignment = .center
        self.diaryDateLabel.textAlignment = .right
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.diaryDateLabel.font = setCustomFont(size: 20)
            self.diaryTitleTextLabel.font = setCustomFont(size: 25)
        } else {
            self.diaryDateLabel.font = setCustomFont(size: 15)
            self.diaryTitleTextLabel.font = setCustomFont(size: 20)
        }
        contentView.addBackground(imageName: "mailcard",  contentMode: .scaleToFill)
        setConstraints()
    }
    
    func configureHomeCollectionViewCell(diarys: Results<Diary>!, indexPath: IndexPath) {
        contentView.addBackground(imageName: "postcard",  contentMode: .scaleToFill)
        self.diaryTitleTextLabel.text = diarys[indexPath.row].diaryTitle
        self.diaryTextView.text = diarys[indexPath.row].diaryContent
        self.diaryDateLabel.text = diarys[indexPath.row].diaryDate.toDetailString
        self.diaryDateLabel.textAlignment = .right
        self.diaryDateLabel.font = setCustomFont(size: 18)
        self.diaryTitleTextLabel.font = setCustomFont(size: 25)
        self.diaryTextView.font = setCustomFont(size: 20)
        setHomeConstraints()
    }
}
