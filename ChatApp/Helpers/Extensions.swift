//
//  Extensions.swift
//  ChatApp
//
//  Created by Vy Le on 4/7/18.
//  Copyright © 2018 Vy Le. All rights reserved.
//

import UIKit

// memory bank for images downloaded below
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            // download hit an error
            if error != nil {
                print("\(String(describing: error))")
                return
            }
            
            // download images to cache
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                
                
                
                
                
            }
            
            
        }).resume()
    }
    
}
