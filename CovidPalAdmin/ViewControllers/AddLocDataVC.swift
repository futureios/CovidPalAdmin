//
//  AddLocDataVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 9/7/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

class AddLocDataVC: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    let nc = NotificationCenter.default
    
    var updateMode: Bool?
    var artwork: Artwork?
    
    var ref: DatabaseReference!
    
    var lat: Double?
    var long: Double?

    let backView = UIStackView()
    
    let stateTextField = UITextField()
    let nameTextField = UITextField()
    let numberTextField = UITextField()
    let descriptionTextField = UITextView()
    let addressTextField = UITextField()

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
          .light: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = pageColor
        ref = Database.database().reference()
        navigationViewInit()
        textFieldInit()
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
        reviewLabel.text = "Post a Location"
        reviewLabel.textColor = textOneColor
        reviewLabel.textAlignment = .center
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        postButton.frame  = CGRect(x: screenSize.width-50, y: 5, width: 40, height: 35)
        postButton.setTitle("Post", for: .normal)
        postButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        postButton.setTitleColor(#colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1), for: .normal)
        postButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        if updateMode! {
            reviewLabel.text = "Updating..."
        }
        
        self.view.addSubview(navigationView)
        self.view.addSubview(cancelButton)
        self.view.addSubview(reviewLabel)
        self.view.addSubview(postButton)
    }
    
    func textFieldInit() {
        backView.frame = CGRect(x: 0, y: 50, width: screenSize.width, height: screenSize.height-94)
        backView.axis  = NSLayoutConstraint.Axis.vertical
        backView.distribution  = UIStackView.Distribution.equalSpacing
        backView.alignment = UIStackView.Alignment.center
        backView.spacing   = 2
        
        makeTextField(field: stateTextField, placeHolder: "state")
        makeTextField(field: nameTextField, placeHolder: "name")
        makeTextField(field: numberTextField, placeHolder: "number")
        numberTextField.keyboardType = .numberPad
        numberTextField.textContentType = .telephoneNumber
        makeTextField(field: addressTextField, placeHolder: "address")
        
        descriptionTextField.heightAnchor.constraint(equalToConstant: 500).isActive = true
        descriptionTextField.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        descriptionTextField.delegate = self
        descriptionTextField.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            }
        }
        descriptionTextField.tintColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        descriptionTextField.text = "description"
        descriptionTextField.textColor = textThreeColor
        descriptionTextField.textAlignment = .left
        descriptionTextField.font = UIFont.boldSystemFont(ofSize: 15)
        descriptionTextField.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let border = UIView()
        border.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case .dark: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            default: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
        border.frame = CGRect(x: 0, y: 0, width: 4, height: descriptionTextField.bounds.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        descriptionTextField.addSubview(border)
        
        if updateMode! {
            stateTextField.text = artwork?.state
            nameTextField.text = artwork?.name
            numberTextField.text = artwork?.number
            addressTextField.text = artwork?.address
            descriptionTextField.text = artwork?.descriptionAddress
            descriptionTextField.textColor = textTwoColor
        }
        
        backView.addArrangedSubview(descriptionTextField)
        self.view.addSubview(backView)
    }
    
    
    func makeTextField(field: UITextField, placeHolder: String) {
        field.heightAnchor.constraint(equalToConstant: 50).isActive = true
        field.widthAnchor.constraint(equalToConstant: screenSize.width).isActive = true
        field.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.9683375955, green: 0.9728185534, blue: 0.9837729335, alpha: 1)
            }
        }
        field.placeholder = placeHolder
        field.tintColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        field.textColor = textOneColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftViewMode = .always
        field.textAlignment = .left
        field.font = UIFont.systemFont(ofSize: 15)
        let border = UIView()
        border.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case .dark: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            default: return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            }
        }
        border.frame = CGRect(x: 0, y: 0, width: 4, height: field.bounds.height)
        border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
        field.addSubview(border)
        backView.addArrangedSubview(field)
    }
    
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      if sender === cancelButton {
        dismiss(animated: true, completion: nil)
      } else if sender === postButton {
        if stateTextField.text!.isReallyEmpty || nameTextField.text!.isReallyEmpty || numberTextField.text!.isReallyEmpty || addressTextField.text!.isReallyEmpty || descriptionTextField.text!.isReallyEmpty {
            Toast.show(message: "Please Enter values", controller: self)
        } else {
            ProgressHUD.show("Add to DB...")
            let description = descriptionTextField.text.trimmingCharacters(in: CharacterSet.newlines)
            let state = stateTextField.text
            let name = nameTextField.text
            let number = numberTextField.text
            let address = addressTextField.text
            if updateMode! {
            Database.database().reference().child("States").child(artwork!.state).child(artwork!.uid).removeValue { error, _ in
                    if let er = error {
                        print(er)
                    }
                    let newRef = self.ref.child("States").child(state!).childByAutoId()
                    newRef.child("Address").setValue(address)
                    newRef.child("Description").setValue(description)
                    newRef.child("Latitude").setValue(self.lat)
                    newRef.child("Longitude").setValue(self.long)
                    newRef.child("Name").setValue(name)
                    newRef.child("Number").setValue(number)
                    ProgressHUD.dismiss()
                    self.nc.post(name: Notification.Name("AddLocation"), object: nil, userInfo: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                let newRef = self.ref.child("States").child(state!).childByAutoId()
                newRef.child("Address").setValue(address)
                newRef.child("Description").setValue(description)
                newRef.child("Latitude").setValue(lat)
                newRef.child("Longitude").setValue(long)
                newRef.child("Name").setValue(name)
                newRef.child("Number").setValue(number)
                ProgressHUD.dismiss()
                self.nc.post(name: Notification.Name("AddLocation"), object: nil, userInfo: nil)
                dismiss(animated: true, completion: nil)
            }
        }
      }
    }
    
    
}


extension AddLocDataVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == textThreeColor {
            textView.text = nil
            textView.textColor = textTwoColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "description"
            textView.textColor = textThreeColor
        }
    }
}
