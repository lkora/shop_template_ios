//
//  ProductImageView.swift
//  prodza
//
//  Created by Luka Korica on 8/6/22.
//

import Foundation
import UIKit

// MARK: - UIImageView - Download the image, cache it, show activity indicator
let cache = NSCache<AnyObject, AnyObject>()
class ProductImageView: UIImageView {

    func downloadImage(from url: URL) {
        if let image = cache.object(forKey: url.absoluteString as NSString) as? UIImage {
            DispatchQueue.main.async {
                self.image = image
                return
            }
        } else {
            let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            activityIndicator.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
            
            self.addSubview(activityIndicator)
            let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let httpURLResponse = response as? HTTPURLResponse,
                        httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data,
                        error == nil,
                        let image = UIImage(data: data)
                        
                else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.image = image
                    cache.setObject(image, forKey: url.absoluteString as NSString)
                    activityIndicator.stopAnimating()
                }
                        
            }
            dataTask.resume()
        }
    }
}
