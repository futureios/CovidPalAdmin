//
//  UsersCell.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import FirebaseUI

class UsersCell: UICollectionViewCell {
    
    var fullNameText: String? {
        get {
            return fullNameLabel.text
        }
        set {
            fullNameLabel.text = newValue
        }
    }
    
    var emailText: String? {
        get {
            return emailLabel.text
        }
        set {
            emailLabel.text = newValue
        }
    }
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 12, y: 10, width: 50, height: 50)
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user-filled")
        iv.layer.borderColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        iv.layer.borderWidth = 1.5
        return iv
    }()
    
    lazy var fullNameLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 74, y: 10, width: UIScreen.main.bounds.width-68, height: 30)
        iv.text = "test"
        iv.textAlignment = .left
        iv.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        iv.font = UIFont.boldSystemFont(ofSize: 15)
        return iv
    }()
    
    lazy var emailLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 74, y: 35, width: UIScreen.main.bounds.width-68, height: 20)
        iv.text = "1@2.com"
        iv.textAlignment = .left
        iv.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        iv.font = UIFont.systemFont(ofSize: 12)
        return iv
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(emailLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhotoValue(photoUrl: String) {
        if photoUrl != "empty" {
            imageView.sd_setImage(with: URL(string: photoUrl), placeholderImage: #imageLiteral(resourceName: "user-filled"))
        }
    }
    
}
