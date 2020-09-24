//
//  UsersVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import IGListKit
import ProgressHUD
import Firebase

class UsersVC: UIViewController, ListAdapterDataSource {
    
    let screenSize: CGRect = UIScreen.main.bounds
    let statusBarHeight = UIApplication.shared.statusBarFrame.height

    var ref: DatabaseReference!

    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView: UICollectionView = {
        let feedLayout = FeedCollectionViewFlowLayout()
        feedLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 44+UIApplication.shared.statusBarFrame.height, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-(44+UIApplication.shared.statusBarFrame.height)), collectionViewLayout: feedLayout)
        collectionView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return collectionView
    }()
    
    let reviewNumLabel = UILabel()
    
    var data: [UsersModel] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        collectionView.collectionViewLayout.register(FeedSeparatorView.self, forDecorationViewOfKind: decoratorIdentifier)
        view.addSubview(collectionView)
        let v = UIView()
        v.frame = CGRect(x: 0, y: screenSize.height-50, width: screenSize.width, height: 50)
        v.backgroundColor = UIColor.white
        view.addSubview(v)
        navigationViewInit()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        
        ProgressHUD.show("Loading...")
        ref.child("Users").observeSingleEvent(of: .value, with: { snapshot in
            for childUID in snapshot.children {
                let uid_snap = childUID as! DataSnapshot
                let uid = uid_snap.key
                guard let dict_user = uid_snap.value as? [String:Any] else {
                    print("Error")
                    return
                }
                let fullName = dict_user["FullName"] as! String
                let email = dict_user["Email"] as! String
                if uid_snap.hasChild("ProfilePicUrl") {
                    let photoUrl = dict_user["ProfilePicUrl"] as! String
                    self.data.append(UsersModel.init(fullName: fullName, profilePic: photoUrl, email: email))
                    self.adapter.performUpdates(animated: false, completion: nil)
                    self.reviewNumLabel.text = "(\(self.data.count))"
                    ProgressHUD.dismiss()
                } else {
                    self.data.append(UsersModel.init(fullName: fullName, profilePic: "empty", email: email))
                    self.adapter.performUpdates(animated: false, completion: nil)
                    self.reviewNumLabel.text = "(\(self.data.count))"
                    ProgressHUD.dismiss()
                }
            }
        })
        
        
    }
    
    func navigationViewInit() {
        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: statusBarHeight, width: screenSize.width, height: 44)
        navigationView.backgroundColor = #colorLiteral(red: 0.9494716525, green: 0.9438272715, blue: 0.9538102746, alpha: 1)
        navigationView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationView.layer.shadowRadius = 1
        navigationView.layer.shadowOpacity = 0.8
        
        let reviewLabel = UILabel()
        reviewLabel.frame = CGRect(x: 0, y: statusBarHeight, width: screenSize.width, height: 44)
        reviewLabel.text = "Users"
        reviewLabel.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        reviewLabel.textAlignment = .center
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 15)

        reviewNumLabel.frame = CGRect(x: 35, y: statusBarHeight, width: screenSize.width, height: 44)
        reviewNumLabel.text = "(\(data.count))"
        reviewNumLabel.textColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        reviewNumLabel.textAlignment = .center
        reviewNumLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.view.addSubview(navigationView)
        self.view.addSubview(reviewLabel)
        self.view.addSubview(reviewNumLabel)
    }
    
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return UserSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
    
    
    
}


private let decoratorIdentifier: String = "horizontalDecorator"


//final class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
//
//        var mutableAttributes = attributes
//        for attribute in attributes {
//            if let horizontal = self.layoutAttributesForDecorationView(ofKind: decoratorIdentifier,
//                                                                       at: attribute.indexPath) {
//                mutableAttributes.append(horizontal)
//            }
//        }
//
//        return mutableAttributes
//    }
//
//    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
//        -> UICollectionViewLayoutAttributes? {
//        guard let itemAttributes = self.layoutAttributesForItem(at: indexPath) else { return nil }
//
//        if indexPath.section == 0 {
//            return nil
//        }
//
//        let attributes = FeedCollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind,
//                                                            with: indexPath)
//        attributes.zIndex = itemAttributes.zIndex + 1
//        attributes.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
//
//        var decorationViewFrame = itemAttributes.frame
//        if elementKind == decoratorIdentifier {
//            decorationViewFrame.size.height = 2.0
//        }
//
//        attributes.frame = decorationViewFrame
//
//        return attributes
//    }
//}
//
//final class FeedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
//    var backgroundColor: UIColor?
//}
//
//final class FeedSeparatorView: UICollectionReusableView {
//
//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//
//        if let attributes = layoutAttributes as? FeedCollectionViewLayoutAttributes {
//            self.backgroundColor = attributes.backgroundColor
//        }
//    }
//}
