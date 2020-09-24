//
//  UsersModel.swift
//  CovidPalAdmin
//
//  Created by Mac OS on 8/31/20.
//  Copyright © 2020 Mac OS. All rights reserved.
//

import UIKit
import IGListKit

final class UsersModel: NSObject {

    let fullName: String
    let profilePic: String
    let email: String

    init(fullName: String, profilePic: String, email: String) {
        self.fullName = fullName
        self.profilePic = profilePic
        self.email = email
    }

}

extension UsersModel: ListDiffable {

    func diffIdentifier() -> NSObjectProtocol {
        return self
    }

    func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        return isEqual(object)
    }

}
