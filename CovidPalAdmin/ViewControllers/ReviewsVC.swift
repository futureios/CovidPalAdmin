//
//  ReviewsVC.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import IGListKit
import Firebase
import FirebaseDatabase
import ProgressHUD

class ReviewsVC: UIViewController, ListAdapterDataSource {
    
    let screenSize: CGRect = UIScreen.main.bounds
    
    var ref: DatabaseReference!

    let nc = NotificationCenter.default

    var state: String?
    var uid: String?

    let closeButton = UIButton()
    let reviewNumLabel = UILabel()
    
    lazy var adapter: ListAdapter = {
        return ListAdapter(updater: ListAdapterUpdater(), viewController: self)
    }()
    let collectionView: UICollectionView = {
        let feedLayout = FeedCollectionViewFlowLayout()
        feedLayout.estimatedItemSize = CGSize(width: 100, height: 40)
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 44, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-84), collectionViewLayout: feedLayout)
        return collectionView
    }()
    
    var data: [ReviewsModel] = []
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nc.addObserver(self, selector: #selector(onDelete), name: Notification.Name("onRevDelete"), object: nil)
        self.collectionView.backgroundColor = pageColor
        data = []
        ref = Database.database().reference()
        collectionView.collectionViewLayout.register(FeedSeparatorView.self, forDecorationViewOfKind: decoratorIdentifier)
        view.addSubview(collectionView)
        navigationViewInit()
        adapter.collectionView = collectionView
        adapter.dataSource = self
        getData()
    }
    
    @objc func onDelete(notification: Notification) {
        getData()
    }
    
    func getData() {
        ProgressHUD.show("Loading...")
        ref.child("States").child(state!).child(uid!).observeSingleEvent(of: .value, with: { snapshot in
            let snap = snapshot
            guard let dict = snap.value as? [String:Any] else {
                print("Error snap")
                return
            }
            //print(snap)
            if snap.hasChild("Reviews") {
                let reviews = (dict["Reviews"] as? NSDictionary)?.allValues
                let rev_uid = (dict["Reviews"] as? NSDictionary)?.allKeys
                var num = 0
                var rev: [ReviewsModel] = []
                for review in reviews! {
                    let dict_rev = review as? NSDictionary
                    let reviewUID = rev_uid![num] as! String
                    num = num+1
                    let rv = dict_rev?["Review"] as! String
                    let timeStamp = dict_rev?["TimeStamp"] as! Int64
                    let turnaroundTime = dict_rev?["TurnaroundTime"] as! Int
                    let turnaroundTimeString = "\(turnaroundTime)"
                    let userID = dict_rev?["UserID"] as! String
                    //print(turnaroundTime)
                    self.ref.child("Users").child(userID).observeSingleEvent(of: .value, with: { snapshot in
                        let snap_user = snapshot
                        guard let dict_user = snapshot.value as? [String:Any] else {
                            print("Error user")
                            return
                        }
                        //print(dict_user)
                        let fullName = dict_user["FullName"] as! String
                        let email = dict_user["Email"] as! String
                        if snap_user.hasChild("ProfilePicUrl") {
                            let profileImage = dict_user["ProfilePicUrl"] as! String
                            rev.append(ReviewsModel(state: self.state!, uid: self.uid!, reviewUID: reviewUID, fullName: fullName, profilePic: profileImage, email: email, review: rv, turnaroundTime: turnaroundTimeString, timeStamp: timeStamp))
                        } else {
                            rev.append(ReviewsModel(state: self.state!, uid: self.uid!, reviewUID: reviewUID, fullName: fullName, profilePic: "empty", email: email, review: rv, turnaroundTime: turnaroundTimeString, timeStamp: timeStamp))
                        }
                        
                        self.data = rev
                        self.adapter.performUpdates(animated: false, completion: nil)
                        self.reviewNumLabel.text = "(\(self.data.count))"
                        ProgressHUD.dismiss()
                    })
                }
            } else { ProgressHUD.dismiss() }
        })
    }
    
    
    
    func navigationViewInit() {
        let navigationView = UIView()
        navigationView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 44)
        navigationView.backgroundColor = backColor
        navigationView.layer.shadowColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        navigationView.layer.shadowOffset = CGSize(width: 0, height: 1)
        navigationView.layer.shadowRadius = 1
        navigationView.layer.shadowOpacity = 0.8
        
        closeButton.frame  = CGRect(x: 12, y: 5, width: 40, height: 35)
        closeButton.setTitle("Close", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        closeButton.setTitleColor(textTwoColor, for: .normal)
        closeButton.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        
        let reviewLabel = UILabel()
        reviewLabel.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: 44)
        reviewLabel.text = "Reviews"
        reviewLabel.textColor = textOneColor
        reviewLabel.textAlignment = .center
        reviewLabel.font = UIFont.boldSystemFont(ofSize: 15)

        let rvCount = data.count
        
        reviewNumLabel.frame = CGRect(x: 45, y: 0, width: screenSize.width, height: 44)
        reviewNumLabel.text = "(\(rvCount))"
        reviewNumLabel.textColor = #colorLiteral(red: 0.9912846684, green: 0.5296337008, blue: 0, alpha: 1)
        reviewNumLabel.textAlignment = .center
        reviewNumLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        self.view.addSubview(navigationView)
        self.view.addSubview(closeButton)
        self.view.addSubview(reviewLabel)
        self.view.addSubview(reviewNumLabel)
    }
    
    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return data as [ListDiffable]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        return ReviewsSectionController()
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }
    
    
    @objc func buttonClicked(_ sender: AnyObject?) {
      if sender === closeButton {
        dismiss(animated: true, completion: nil)
      }
    }
    
    
}




private let decoratorIdentifier: String = "horizontalDecorator"

final class FeedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }

        var mutableAttributes = attributes
        for attribute in attributes {
            if let horizontal = self.layoutAttributesForDecorationView(ofKind: decoratorIdentifier,
                                                                       at: attribute.indexPath) {
                mutableAttributes.append(horizontal)
            }
        }

        return mutableAttributes
    }

    override func layoutAttributesForDecorationView(ofKind elementKind: String, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes? {
        guard let itemAttributes = self.layoutAttributesForItem(at: indexPath) else { return nil }

        if indexPath.section == 0 {
            return nil
        }
        
        let attributes = FeedCollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind,
                                                            with: indexPath)
        attributes.zIndex = itemAttributes.zIndex + 1
        attributes.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case
              .unspecified,
              .light: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            case .dark: return #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            default: return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 0.5)
            }
        }

        var decorationViewFrame = itemAttributes.frame
        if elementKind == decoratorIdentifier {
            decorationViewFrame.size.height = 2.0
        }

        attributes.frame = decorationViewFrame

        return attributes
    }
}

final class FeedCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
    var backgroundColor: UIColor?
}

final class FeedSeparatorView: UICollectionReusableView {

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        if let attributes = layoutAttributes as? FeedCollectionViewLayoutAttributes {
            self.backgroundColor = attributes.backgroundColor
        }
    }
}
