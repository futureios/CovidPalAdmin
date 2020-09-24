//
//  PostReviewsVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class PostReviewsVC: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var ref: DatabaseReference!
    
    let nc = NotificationCenter.default

    var state: String?
    var uid: String?
    var reviewUID: String?
    
    var updateMode: Bool?
    var reviewString: String?
    var turnaroundString: String?
    
    let reviewTextField = UITextView()
    let turnaroundTextField = UITextField()
    
    let cancelButton = UIButton()
    let postButton = UIButton()
    
    let pageColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .dark: return UIColor.systemGray6
        default: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    let backColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.9494716525, green: 0.9438272715, blue: 0.9538102746, alpha: 1)
        case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        default: return #colorLiteral(red: 0.9494716525, green: 0.9438272715, blue: 0.9538102746, alpha: 1)
        }
    }
    
    let backTwoColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
        case .dark: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
        }
    }
    
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
          .light: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        }
    }
    
    let textThreeColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pageColor
        ref = Database.database().reference()
        navigationViewInit()
        boxesViewInit()
    }
    
    func navigationViewInit() {
        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 44)
        navigationView.backgroundColor = backColor
        navigationView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationView.layer.shadowRadius = 1
        navigationView.layer.shadowOpacity = 0.8
        
        cancelButton.frame  = CGRect(x: 12, y: 5, width: 40, height: 35)
        cancelButton.setTitle("Close", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        cancelButton.setTitleColor(textOneColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let reviewLabel = UILabel()
        reviewLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 44)
        if updateMode! {
            reviewLabel.text = "Updating..."
        } else {
            reviewLabel.text = "Post a Review"
        }
        reviewLabel.textColor = textOneColor
        reviewLabel.textAlignment = .center
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        postButton.frame  = CGRect(x: screenSize.width-50, y: 5, width: 40, height: 35)
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        postButton.setTitleColor(#colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1), for: .normal)
        postButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        self.view.addSubview(navigationView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(reviewLabel)
        self.view.addSubview(postButton)
    }
    
    func boxesViewInit() {
        reviewTextField.frame = CGRect(x: 0, y: 54, width: screenSize.width, height: 250)
        reviewTextField.delegate = self
        reviewTextField.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            }
        }
        reviewTextField.tintColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        reviewTextField.textColor = textThreeColor
        reviewTextField.textAlignment = .left
        reviewTextField.font = UIFont.boldSystemFont(ofSize: 15)
        reviewTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        let borderOne = UIView()
        borderOne.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case .dark: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            default: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
        borderOne.frame = CGRect(x: 0, y: 0, width: 4, height: reviewTextField.bounds.height)
        borderOne.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        reviewTextField.addSubview(borderOne)
        
        let rightView = UIView(frame: CGRect(x: screenSize.width-60, y: 0, width: 60, height: 50))
        let textRightView = UILabel()
        textRightView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        textRightView.text = "Days"
        textRightView.textColor = textOneColor
        textRightView.textAlignment = .center
        textRightView.font = UIFont.systemFont(ofSize: 14)
        rightView.addSubview(textRightView)
        
        turnaroundTextField.frame = CGRect(x: 0, y: 314, width: screenSize.width, height: 50)
        turnaroundTextField.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            }
        }
        turnaroundTextField.placeholder = "Turnaround"
        turnaroundTextField.tintColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        turnaroundTextField.textColor = textOneColor
        turnaroundTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: turnaroundTextField.frame.height))
        turnaroundTextField.leftViewMode = .always
        turnaroundTextField.textAlignment = .left
        turnaroundTextField.rightView = rightView
        turnaroundTextField.rightViewMode = .always
        turnaroundTextField.keyboardType = .numberPad
        turnaroundTextField.font = UIFont.systemFont(ofSize: 15)

        let borderTwo = UIView()
        borderTwo.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case .dark: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            default: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }

        borderTwo.frame = CGRect(x: 0, y: 0, width: 4, height: turnaroundTextField.bounds.height)
        borderTwo.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        turnaroundTextField.addSubview(borderTwo)
        
        if updateMode! {
            reviewTextField.text = reviewString
            turnaroundTextField.text = turnaroundString
            reviewTextField.textColor = textOneColor
        } else {
            reviewTextField.text = "Write a Review..."
            turnaroundTextField.text = ""
        }
        
        self.view.addSubview(reviewTextField)
        self.view.addSubview(turnaroundTextField)
    }
    
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      if sender === cancelButton {
        dismiss(animated: true, completion: nil)
      } else if sender === postButton {
        if reviewTextField.text.isReallyEmpty || turnaroundTextField.text!.isReallyEmpty {
            Toast.show(message: "Please Enter values", controller: self)
        } else {
            ProgressHUD.show("Add to DB...")
            let review = reviewTextField.text.trimmingCharacters(in: CharacterSet.newlines)
            let timeStamp = Date().currentTimeMillis()
            let lastTimeStamp = (0 - timeStamp)
            let turnaroundTime = Int(turnaroundTextField.text!)
            let userID = Auth.auth().currentUser?.uid
            if updateMode! {
                let updateRef = self.ref.child("States").child(state!).child(uid!).child("Reviews").child(reviewUID!)
                updateRef.updateChildValues(["Review": review])
                updateRef.updateChildValues(["TimeStamp": lastTimeStamp])
                updateRef.updateChildValues(["TurnaroundTime": turnaroundTime!])
                ProgressHUD.dismiss()
                self.nc.post(name: Notification.Name("onRevDelete"), object: nil, userInfo: nil)
                dismiss(animated: true, completion: nil)
            } else {
                let newRef = self.ref.child("States").child(state!).child(uid!).child("Reviews").childByAutoId()
                newRef.child("Review").setValue(review)
                newRef.child("TimeStamp").setValue(lastTimeStamp)
                newRef.child("TurnaroundTime").setValue(turnaroundTime)
                newRef.child("UserID").setValue(userID)
                ProgressHUD.dismiss()
                dismiss(animated: true, completion: nil)
            }
        }
      }
    }
    
    
}


extension PostReviewsVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textThreeColor {
            textView.text = nil
            textView.textColor = textOneColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Post a Review..."
            textView.textColor = textThreeColor
        }
    }
}
