//
//  KeyVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 9/23/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit

class KeyVC: UIViewController {
    
    let trueNum = "8679300"
    
    @IBOutlet weak var textFeild: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button.layer.cornerRadius = 8
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        let text = textFeild.text
        if trueNum == text {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:false, completion:nil)
        } else {
            Toast.show(message: "incorrect", controller: self)
        }
    }
    
    
}
