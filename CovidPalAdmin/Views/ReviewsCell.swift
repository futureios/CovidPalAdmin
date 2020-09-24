//
//  ReviewsCell.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import FirebaseUI

class ReviewsCell: SwipeTableViewCell {
    
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
    
    var reviewText: String?
    
    var turnaroundTimeText: String?
    
    var timeStampText: String?
    
    
    lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.frame = CGRect(x: 12, y: 10, width: 40, height: 40)
        iv.layer.cornerRadius = 20
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "user-filled").withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
        iv.layer.borderColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        iv.layer.borderWidth = 1.2
        return iv
    }()
    
    lazy var fullNameLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 56, y: 10, width: UIScreen.main.bounds.width-68, height: 25)
        iv.text = "test"
        iv.textAlignment = .left
        iv.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
        iv.font = UIFont.boldSystemFont(ofSize: 12)
        return iv
    }()
    
    lazy var emailLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 56, y: 30, width: UIScreen.main.bounds.width-68, height: 15)
        iv.text = "1@2.com"
        iv.textAlignment = .left
        iv.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            default: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            }
        }
        iv.font = UIFont.systemFont(ofSize: 9)
        return iv
    }()
    
    lazy var reviewTitleLabel: UILabel = {
        let iv = UILabel()
        iv.frame = CGRect(x: 12, y: 58, width: 100, height: 12)
        iv.text = "Review:"
        iv.textAlignment = .left
        iv.textColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            }
        }
        iv.font = UIFont.boldSystemFont(ofSize: 13)
        return iv
    }()
    
    var reviewLabel = PaddingLabel()
    
    var turnaroundTimeTitleLabel = UILabel()
    
    var turnaroundTimeLabel = UILabel()
    
    var timeStampLabel = UILabel()
    
    let textOneColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    let textTwoColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    static func cellSize(text: String) -> CGFloat {
        return textSize(text: text, font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width-48).size.height+124
    }
    
    static func textSize(text: String, font: UIFont, width: CGFloat) -> CGRect {
        let constrainedSize = CGSize(width: width, height: .greatestFiniteMagnitude)
      let attributes = [NSAttributedString.Key.font: font]
      let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
      let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
      return bounds
    }
    
    static func textSizeWidth(text: String, font: UIFont, height: CGFloat) -> CGRect {
        let constrainedSize = CGSize(width: .greatestFiniteMagnitude, height: height)
      let attributes = [NSAttributedString.Key.font: font]
      let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
      let bounds = (text as NSString).boundingRect(with: constrainedSize, options: options, attributes: attributes, context: nil)
      return bounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    func setLabelsValue(review: String, turnaroundTime: String, timeStamp: String, profileUrl: String) {
        reviewText = review
        turnaroundTimeText = turnaroundTime
        timeStampText = timeStamp
        viewInit()
        contentView.addSubview(imageView)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(emailLabel)
        contentView.addSubview(reviewTitleLabel)
        contentView.addSubview(reviewLabel)
        contentView.addSubview(turnaroundTimeTitleLabel)
        contentView.addSubview(turnaroundTimeLabel)
        contentView.addSubview(timeStampLabel)
        if profileUrl != "empty" {
            imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: #imageLiteral(resourceName: "user-filled"))
        }
    }
    
    func viewInit() {
        reviewLabel.frame = CGRect(x: 16, y: 80, width: UIScreen.main.bounds.width-32, height: ReviewsCell.textSize(text: reviewText!, font: UIFont.systemFont(ofSize: 12), width: UIScreen.main.bounds.width-48).size.height+10)
        reviewLabel.text = reviewText
        reviewLabel.textAlignment = .left
        reviewLabel.textColor = textTwoColor
        reviewLabel.lineBreakMode = .byWordWrapping
        reviewLabel.numberOfLines = 0
        reviewLabel.font = UIFont.systemFont(ofSize: 12)
        reviewLabel.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            }
        }
        reviewLabel.layer.cornerRadius = 25
        reviewLabel.layer.shadowColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            }
        }.cgColor
        reviewLabel.layer.shadowOffset = CGSize(width: 0, height: 1)
        reviewLabel.layer.shadowRadius = 1
        reviewLabel.layer.shadowOpacity = 0.8
        
        let border = UIView()
        border.backgroundColor = textTwoColor
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: reviewLabel.bounds.width, height: 1)
        reviewLabel.addSubview(border)
        
        turnaroundTimeTitleLabel.frame = CGRect(x: 12, y: 92+reviewLabel.bounds.height, width: 120, height: 12)
        turnaroundTimeTitleLabel.text = "Turnaround Time:"
        turnaroundTimeTitleLabel.textAlignment = .left
        turnaroundTimeTitleLabel.textColor = textOneColor
        turnaroundTimeTitleLabel.font = UIFont.boldSystemFont(ofSize: 13)
        
        turnaroundTimeLabel.frame = CGRect(x: 130, y: 92+reviewLabel.bounds.height, width: 100, height: 12)
        turnaroundTimeLabel.text = turnaroundTimeText
        turnaroundTimeLabel.textAlignment = .left
        turnaroundTimeLabel.textColor = textTwoColor
        turnaroundTimeLabel.font = UIFont.systemFont(ofSize: 11)
        
        timeStampLabel.frame = CGRect(x: UIScreen.main.bounds.width-(ReviewsCell.textSizeWidth(text: timeStampText!, font: UIFont.systemFont(ofSize: 10), height: 10).size.width+12), y: 94+reviewLabel.bounds.height, width: ReviewsCell.textSizeWidth(text: timeStampText!, font: UIFont.systemFont(ofSize: 10), height: 10).size.width, height: 10)
        timeStampLabel.text = timeStampText
        timeStampLabel.textAlignment = .left
        timeStampLabel.textColor = textTwoColor
        timeStampLabel.font = UIFont.systemFont(ofSize: 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class PaddingLabel: UILabel {

    var topInset: CGFloat = 5.0
    var bottomInset: CGFloat = 5.0
    var leftInset: CGFloat = 8.0
    var rightInset: CGFloat = 8.0

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }

    override var bounds: CGRect {
        didSet {
            // ensures this works within stack views if multi-line
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
