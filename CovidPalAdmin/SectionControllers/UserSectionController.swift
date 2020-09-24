//
//  UserSectionController.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import IGListKit
import UIKit

class UserSectionController: ListSectionController {
    
    private var model: UsersModel?

    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: (collectionContext?.containerSize.width)!, height: 70)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        guard let cell = collectionContext?.dequeueReusableCell(of: UsersCell.self, for: self, at: index) as? UsersCell else{
            fatalError()
        }
        cell.fullNameText = model!.fullName
        cell.emailText = model!.email
        cell.setPhotoValue(photoUrl: model!.profilePic)
        return cell
    }

    override func didUpdate(to object: Any) {
        self.model = object as? UsersModel
    }
    
}
