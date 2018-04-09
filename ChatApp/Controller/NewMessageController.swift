//
//  NewMessageController.swift
//  ChatApp
//
//  Created by Vy Le on 4/7/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {
    
    let cellId = "cellId"
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        
        fetchUser()
        
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in

            if let dictonary = snapshot.value as? [String: AnyObject] {
                let user = User()
                user.setValuesForKeys(dictonary)
                self.users.append(user)
                
                // This will crash because of background thread, so let's use DispatchQueue.main.async to fix
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }


        }, withCancel: nil)
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        let user = users[indexPath.row]
        
        
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        
        
        
        if let profileImageUrl = user.profileImageUrl {
           
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }


}

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
