//
//  Message.swift
//  ChatApp
//
//  Created by Vy Le on 4/9/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    
    var fromId: String?
    var text: String?
    var toId: String?
    var timestamp: NSNumber?
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    init(dictionary: [String: Any]) {
        self.fromId = dictionary["fromId"] as? String
        self.text = dictionary["text"] as? String
        self.toId = dictionary["toId"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
        self.videoUrl = dictionary["videoUrl"] as? String
    }
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
        
    }
    
}
