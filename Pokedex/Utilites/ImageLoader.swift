//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine
import UIKit

class ImageLoader: ObservableObject {
    @Published var displayImage: UIImage?
    var imageUrl: String?
    var cachedImage = CachedImage.getCachedImage()
    
    init(url: String) {
        self.imageUrl = url
        if imageFromCache() {
            return
        }
        imageFromRemoteUrl()
    }
    
    func imageFromCache() -> Bool {
        guard let url = imageUrl, let cacheImage = cachedImage.get(key: url) else {
            return false
        }
        displayImage = cacheImage
        return true
    }
    
    func imageFromRemoteUrl() {
        guard let url = imageUrl else {
            return
        }
        
        let imageURL = URL(string: url)!
        
        URLSession.shared.dataTask(with: imageURL, completionHandler: { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    guard let remoteImage = UIImage(data: data) else {
                        return
                    }
                    self.cachedImage.set(key: self.imageUrl!, image: remoteImage)
                    self.displayImage = remoteImage
                }
            }
        }).resume()
    }
}


class CachedImage {
    var cache = NSCache<NSString, UIImage>()
    
    func get(key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func set(key: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}

extension CachedImage {
    private static var cachedImage = CachedImage()
    static func getCachedImage() -> CachedImage {
        return cachedImage
    }
}
