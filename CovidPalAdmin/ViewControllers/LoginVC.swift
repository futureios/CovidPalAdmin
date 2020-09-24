//
//  LoginVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 9/7/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import ProgressHUD

class LoginVC: UIViewController {
    
    let screenSize: CGRect = UIScreen.main.bounds
    private var presentingController: UIViewController?

    let feildBoxView = UIView()
    let emailTextField = UITextField()
    let visibilityButton = UIButton()
    let passwordTextField = UITextField()
    let nextButton = UIButton()
    
    let backBoxesColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        default: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    let boxesShadowColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
    
    let textOneColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        case .dark: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        default: return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
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
    
    let whiteBlackColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case
          .unspecified,
          .light: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case .dark: return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        default: return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        presentingController = presentingViewController

        self.view.backgroundColor = UIColor.systemGray6
        
        makeCircle(mX: -(screenSize.width*0.4), mY: -(screenSize.height*0.13), mWidth: screenSize.width, mHeight: screenSize.height * 0.4)
        
        let statusBar = UIView()
        statusBar.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: UIApplication.shared.statusBarFrame.height)
        statusBar.backgroundColor = whiteBlackColor
        self.view.addSubview(statusBar)
        
        makeCircle(mX: screenSize.width*0.55, mY: screenSize.height*0.8, mWidth: screenSize.width*0.8, mHeight: screenSize.height*0.4)
                
        loginLabelInit()
        textFeildBoxInit()
        nextButtonInit()
        
        ProgressHUD.colorStatus = .darkGray
    }
    
    func loginLabelInit() {
        let loginLabel = UILabel()
        loginLabel.frame = CGRect(x: screenSize.width*0.72, y: screenSize.height*0.18, width: 80, height: 40)
        loginLabel.text = "Login"
        loginLabel.font = UIFont.boldSystemFont(ofSize: 22)
        loginLabel.textColor = textOneColor
        self.view.addSubview(loginLabel)
    }
    
    func makeCircle(mX: CGFloat, mY: CGFloat, mWidth: CGFloat, mHeight: CGFloat) {
        let mView = UIView()
        mView.frame = CGRect(x: mX, y: mY, width: mWidth, height: mHeight)
        mView.layer.borderWidth = 2
        mView.layer.borderColor = UIColor.gray.cgColor
        mView.layer.cornerRadius = mView.frame.height/2
        mView.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = mView.bounds
        //gradient.colors = [#colorLiteral(red: 0.7459173799, green: 0.08396025747, blue: 0.03161457554, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.4760369658, blue: 0, alpha: 1).cgColor]
        gradient.colors = [#colorLiteral(red: 0.8614602685, green: 0.3087803423, blue: 0.06334851682, alpha: 1).cgColor, #colorLiteral(red: 0.9195799232, green: 0.5436010957, blue: 0.04618889838, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.masksToBounds = true
        mView.layer.insertSublayer(gradient, at: 0)
        self.view.addSubview(mView)
    }
    
    func textFeildBoxInit() {
        feildBoxView.frame = CGRect(x: 0, y: screenSize.height*0.35, width: screenSize.width*0.85, height: 108)
        feildBoxView.backgroundColor = backBoxesColor
        feildBoxView.layer.cornerRadius = 54
        feildBoxView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        feildBoxView.layer.shadowColor = boxesShadowColor.cgColor
        feildBoxView.layer.shadowOffset = CGSize(width: -1, height: 2)
        feildBoxView.layer.shadowOpacity = 1
        feildBoxView.layer.shadowRadius = 0.5
        self.view.addSubview(feildBoxView)
        emailTextFieldInit()
        passwordTextFieldInit()
    }
    
    func emailTextFieldInit() {
        let emailImageView = UIImageView()
        emailImageView.frame = CGRect(x: 16, y: 16, width: 20, height: 20)
        emailImageView.image = #imageLiteral(resourceName: "message").withRenderingMode(.alwaysTemplate)
        emailImageView.tintColor = UIColor.orange
        emailTextField.frame = CGRect(x: 46, y: 0, width: screenSize.width*0.6, height: 52)
        emailTextField.backgroundColor = UIColor.init(white: 0, alpha: 0)
        emailTextField.placeholder = "Email"
        emailTextField.tintColor = UIColor.orange
        emailTextField.textColor = textTwoColor
        emailTextField.textContentType = .emailAddress
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = UITextAutocapitalizationType.none
        let dividerView = UIView()
        dividerView.frame = CGRect(x: 0, y: 53.5, width: screenSize.width*0.85, height: 1)
        dividerView.backgroundColor = boxesShadowColor
        self.feildBoxView.addSubview(emailImageView)
        self.feildBoxView.addSubview(emailTextField)
        self.feildBoxView.addSubview(dividerView)
    }
    
    func passwordTextFieldInit() {
        visibilityButton.frame = CGRect(x: ((screenSize.width*0.6)+30), y: 68, width: 28, height: 28)
        visibilityButton.setImage( #imageLiteral(resourceName: "not-visibility").withRenderingMode(.alwaysTemplate), for: .normal)
        visibilityButton.tintColor = textOneColor
        visibilityButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        let passwordImageView = UIImageView()
        passwordImageView.frame = CGRect(x: 16, y: 72, width: 20, height: 20)
        passwordImageView.image = #imageLiteral(resourceName: "passLock").withRenderingMode(.alwaysTemplate)
        passwordImageView.tintColor = UIColor.orange
        passwordTextField.frame = CGRect(x: 46, y: 56, width: screenSize.width*0.57, height: 52)
        passwordTextField.backgroundColor = UIColor.init(white: 0, alpha: 0)
        passwordTextField.placeholder = "Password"
        passwordTextField.tintColor = UIColor.orange
        passwordTextField.textColor = textTwoColor
        passwordTextField.textContentType = .oneTimeCode
        passwordTextField.isSecureTextEntry = true
        self.feildBoxView.addSubview(passwordImageView)
        self.feildBoxView.addSubview(passwordTextField)
        self.feildBoxView.addSubview(visibilityButton)
    }
    
    func nextButtonInit() {
        nextButton.frame = CGRect(x: screenSize.width*0.75, y: ((screenSize.height*0.35)+20), width: 68, height: 68)
        nextButton.backgroundColor = UIColor.orange
        nextButton.layer.cornerRadius = 34
        nextButton.clipsToBounds = true
        let gradient = CAGradientLayer()
        gradient.frame = nextButton.bounds
        //gradient.colors = [#colorLiteral(red: 0.7459173799, green: 0.08396025747, blue: 0.03161457554, alpha: 1).cgColor, #colorLiteral(red: 1, green: 0.4760369658, blue: 0, alpha: 1).cgColor]
        gradient.colors = [#colorLiteral(red: 0.8614602685, green: 0.3087803423, blue: 0.06334851682, alpha: 1).cgColor, #colorLiteral(red: 0.9195799232, green: 0.5436010957, blue: 0.04618889838, alpha: 1).cgColor]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.masksToBounds = true
        nextButton.layer.insertSublayer(gradient, at: 0)
        let nextImageView = UIImageView()
        nextImageView.frame = CGRect(x: 18, y: 19, width: 32, height: 30)
        nextImageView.image = #imageLiteral(resourceName: "right-arrow").withRenderingMode(.alwaysTemplate)
        nextImageView.tintColor = UIColor.white
        self.view.addSubview(nextButton)
        nextButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        nextButton.addSubview(nextImageView)

    }
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
      if sender === nextButton {
        
        if emailTextField.text!.isReallyEmpty || passwordTextField.text!.isReallyEmpty {
            Toast.show(message: "Please Enter values", controller: self)
        } else {
            ProgressHUD.show("Authentication...")
            fbSingIn(email: emailTextField.text!, password: passwordTextField.text!)
        }
        
      } else if sender === visibilityButton {
        passwordTextField.isSecureTextEntry.toggle()
        if passwordTextField.isSecureTextEntry == false {
            visibilityButton.setImage( #imageLiteral(resourceName: "visibility").withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            visibilityButton.setImage( #imageLiteral(resourceName: "not-visibility").withRenderingMode(.alwaysTemplate), for: .normal)
        }
      }
        
    }
    
    
    func fbSingIn(email: String, password: String) {
        nextButton.isEnabled = false
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error == nil  {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "MainVC") as! MainVC
                nextViewController.modalPresentationStyle = .fullScreen
                ProgressHUD.dismiss()
                self.present(nextViewController, animated:false, completion:nil)
            } else {
                self.nextButton.isEnabled = true
                ProgressHUD.dismiss()
                Toast.show(message: "Sign In Failed", controller: self)
            }
        }
    }


}

