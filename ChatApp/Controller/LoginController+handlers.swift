//
//  LoginController+handlers.swift
//  ChatApp
//
//  Created by Vy Le on 4/7/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("***** Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print("***** Unable to authenticate with Firebase email: \(String(describing: error))")
                return
            }
            
            self.handleRegister()
            guard let uid = user?.uid else {
                return
            }
            
            // Upload image into Firebase Storage
            let imageName = UUID().uuidString
            let storageRef = Storage.storage().reference().child("myImage.png").child("profile_images").child("\(imageName).jpg")
            if let profileImage = self.profileImageView.image,
                
                let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString {
                        
                        let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                })
            }
        })
    }
    
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)

        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("***** \(String(describing: err))")
                return
            }
            
            print("****** Successfully save user in Firebase")
            self.messagesController?.navigationItem.title = values["name"] as? String
            
            self.dismiss(animated: true, completion: nil)
        })
    }

    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
}
