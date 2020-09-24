//
//  ReviewsSectionController.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import IGListKit
import UIKit
import Firebase


class ReviewsSectionController: ListSectionController {
    
    private var model: ReviewsModel?
    
    let nc = NotificationCenter.default

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: ReviewsCell.cellSize(text: model!.review))
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: ReviewsCell.self, for: self, at: index) as? ReviewsCell else{
            fatalError()
        }
        cell.fullNameText = model!.fullName
        cell.emailText = model!.email
        
        let newTime = (0 - model!.timeStamp)
        let unixTimeStamp: Double = Double(newTime) / 1000.0
        let date = Date(timeIntervalSince1970: unixTimeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss a"
        let timeString = dateFormatter.string(from: date)
        
        cell.setLabelsValue(review: model!.review, turnaroundTime: "\(model!.turnaroundTime) Days", timeStamp: "\(timeString)", profileUrl: model!.profilePic)
        
        cell.delegate = self
        
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = object as? ReviewsModel
    }
    
}

extension ReviewsSectionController: SwipeTableViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            Database.database().reference().child("States").child(self.model!.state).child(self.model!.uid).child("Reviews").child(self.model!.reviewUID).removeValue { error, _ in
                if let er = error {
                    print(er)
                }
                self.nc.post(name: Notification.Name("onRevDelete"), object: nil, userInfo: nil)
            }
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.6)
        
        let editAction = SwipeAction(style: .default, title: "Edit") { action, indexPath in
            let vc = self.viewController as! ReviewsVC
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let postReviewsVC = storyBoard.instantiateViewController(withIdentifier: "PostReviewsVC") as! PostReviewsVC
            postReviewsVC.modalPresentationStyle = .formSheet
            postReviewsVC.state = self.model?.state
            postReviewsVC.uid = self.model?.uid
            postReviewsVC.reviewUID = self.model?.reviewUID
            postReviewsVC.updateMode = true
            postReviewsVC.reviewString = self.model?.review
            postReviewsVC.turnaroundString = self.model?.turnaroundTime
            vc.present(postReviewsVC, animated:true, completion:nil)
        }
        editAction.image = UIImage(systemName: "square.and.pencil")
        editAction.backgroundColor = #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 0.3)

        return [deleteAction,editAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .border
        return options
    }
    
}
