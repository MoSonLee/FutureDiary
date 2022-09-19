//
//  HomeCollectionViewCell.swift
//  FutureDiary
//
//  Created by 이승후 on 2022/09/09.
//

import UIKit

import RealmSwift

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
        //        setConstraints()
    }
    
    private func setConfigure() {
        [diaryTitleTextLabel, diaryTextView, diaryDateLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        diaryTextView.isEditable = false
        diaryTextView.isUserInteractionEnabled = false
        diaryTitleTextLabel.insetsLayoutMarginsFromSafeArea = true
        diaryTitleTextLabel.numberOfLines = 0
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
        
        contentView.backgroundColor = UIColor(patternImage:  UIImage(named: "letter")!)
    }
    
    private func setConstraints() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            NSLayoutConstraint.activate([
                diaryTitleTextLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
                diaryTitleTextLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
                diaryTitleTextLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
                
                diaryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
                diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
                diaryDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),
            ])
        } else {
            NSLayoutConstraint.activate([
                
                diaryTitleTextLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
                diaryTitleTextLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),

                diaryTitleTextLabel.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
                diaryTitleTextLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor, constant:  -16),
                
                diaryDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 1),
                diaryDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
                diaryDateLabel.topAnchor.constraint(equalTo: diaryTitleTextLabel.bottomAnchor, constant: 16),
            ])
        }
    }
    
     func setHomeConstraints() {
        NSLayoutConstraint.activate([
            diaryTitleTextLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            diaryTitleTextLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            diaryTitleTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1),
            diaryTitleTextLabel.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            
            diaryTextView.topAnchor.constraint(equalTo: diaryTitleTextLabel.bottomAnchor, constant: 50),
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
        
        self.diaryTitleTextLabel.font = .systemFont(ofSize: 12)
        self.diaryTextView.font = .systemFont(ofSize: 10)
        self.diaryDateLabel.font = .systemFont(ofSize: 10)
        contentView.backgroundColor = UIColor(patternImage:  UIImage(named: "letter")!)
        setConstraints()
    }
    
    func configureSearchCollectionViewCell(searchedDiary: [Diary], indexPath: IndexPath) {
        
        self.diaryTitleTextLabel.text = searchedDiary[indexPath.row].diaryTitle
        self.diaryTextView.text = searchedDiary[indexPath.row].diaryContent
        self.diaryDateLabel.text = searchedDiary[indexPath.row].diaryDate.toDetailString
        self.diaryDateLabel.font = .systemFont(ofSize: 10)
        self.diaryDateLabel.textAlignment = .center
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
        contentView.backgroundColor = UIColor(patternImage:  UIImage(named: "letter")!)
        setConstraints()
    }
    
    func configureHomeCollectionViewCell(diarys: Results<Diary>!, indexPath: IndexPath) {
        self.diaryTitleTextLabel.text = diarys[indexPath.row].diaryTitle
        self.diaryTextView.text = diarys[indexPath.row].diaryContent
        self.diaryDateLabel.text = diarys[indexPath.row].diaryDate.toDetailString
        self.diaryDateLabel.textAlignment = .right
        self.diaryDateLabel.adjustsFontSizeToFitWidth = true
        setHomeConstraints()
    }
}
