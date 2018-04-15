//
//  UserCell.swift
//  ChatApp
//
//  Created by Vy Le on 4/14/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit
import Firebase

class UserCell: UITableViewCell {
    
    var message: Message? {
        didSet {
            
            if let toId = message?.toId {
                let ref = Database.database().reference().child("users").child(toId)
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String:AnyObject] {
                        print(snapshot)
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["porfileImageUrl"] as? String {
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
                        }
                    }
                    
                }, withCancel: nil)
            }
            
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        textLabel?.frame = CGRect(x: 64, y: (textLabel!.frame.origin.y), width: self.frame.size.width, height: textLabel!.frame.height)
        
        
        detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel!.frame.origin.y), width: self.frame.size.width, height: detailTextLabel!.frame.height)
        
    }
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "nedstark")
        iv.contentMode = .scaleAspectFill
        //iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
        
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "HH:MM:SS"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        addSubview(timeLabel)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        timeLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 25).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        timeLabel.heightAnchor.constraint(equalTo: (textLabel?.heightAnchor)!).isActive = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

