//
//  MainVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import ESTabBarController_swift
import GoogleMobileAds

class MainVC: ESTabBarController {
    
    var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBar = self.tabBar as? ESTabBar {
            tabBar.itemCustomPositioning = .fillIncludeSeparator
        }
        
        self.delegate = delegate
        self.title = "tabBar"
        
        let v1 = self.storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
        let v2 = self.storyboard?.instantiateViewController(withIdentifier: "UsersVC") as! UsersVC
        
        v1.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: "Covid-19 Centers", image: #imageLiteral(resourceName: "globe"), selectedImage: #imageLiteral(resourceName: "globe-filled"))
        v2.tabBarItem = ESTabBarItem.init(ExampleBasicContentView(), title: "Users", image: #imageLiteral(resourceName: "users"), selectedImage: #imageLiteral(resourceName: "user-filled"))

        self.viewControllers = [v1, v2]

        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-3968155913449963/2897692783"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var height = self.tabBar.bounds.size.height
        if #available(iOS 11.0, *) {
            height -= self.view.safeAreaInsets.bottom
            if self.view.safeAreaInsets.bottom != 0 {
                height += 4
            }
        }
        tabBar.frame.size.height = height
    }

    func addBannerViewToView(_ bannerView: GADBannerView) {
      bannerView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(bannerView)
      view.addConstraints(
        [NSLayoutConstraint(item: bannerView,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: tabBar,
                            attribute: .top,
                            multiplier: 1,
                            constant: 0),
         NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
        ])
     }
    
}
