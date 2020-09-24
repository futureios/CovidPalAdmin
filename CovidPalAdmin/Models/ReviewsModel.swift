//
//  ReviewsModel.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import IGListKit

final class ReviewsModel: NSObject {

    let state: String
    let uid: String
    let reviewUID: String
    let fullName: String
    let profilePic: String
    let email: String
    let review: String
    let turnaroundTime: String
    let timeStamp: Int64

    init(state: String, uid: String, reviewUID: String,fullName: String, profilePic: String, email: String, review: String, turnaroundTime: String, timeStamp: Int64) {
        self.state = state
        self.uid = uid
        self.reviewUID = reviewUID
        self.fullName = fullName
        self.profilePic = profilePic
        self.email = email
        self.review = review
        self.turnaroundTime = turnaroundTime
        self.timeStamp = timeStamp
    }

}

extension ReviewsModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }

}
