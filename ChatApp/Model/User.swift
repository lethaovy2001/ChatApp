//
//  User.swift
//  ChatApp
//
//  Created by Vy Le on 4/7/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit

class User: NSObject {

    @objc var name: String?
    @objc var email: String?
    @objc var profileImageUrl: String?
    @objc var id: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
    }
}
