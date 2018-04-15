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
                let user = User(dictionary: dictonary)
                user.id = snapshot.key
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
    
    var messagesController: MessagesController?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = self.users[indexPath.row]
        
        dismiss(animated: true, completion: nil)
        self.messagesController?.showChatControllerForUser(user: user)
    }
    
    


}

