//
//  ImageLoader.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/5/20.
//

import Foundation
import Combine
import UIKit
import func AVFoundation.AVMakeRect

class ImageLoader: ObservableObject {
    @Published var displayImage: UIImage?
    private var cancellables = Set<AnyCancellable>()
    private var imageCache = ImageCache.getImageCache()
    private var url: String
    private var retry = false {
        didSet {
            if retry {
                loadFrontDefaultUrl(from: url)
            }
        }
    }
    
    
    init(url: String) {
        self.url = url
        loadImage(from: url)
    }
        
    deinit {
        print("deinit - \(url)")
    }
    
    private func loadImage(from urlString: String) {
        if let image = imageCache.get(forKey: urlString)  {
            displayImage = image
            return
        }

        guard let url = URL(string: urlString) else {
            return
        }
        
        loadOfficialImageFromUrl(url: url, key: urlString)
        
    }
    
    private func loadOfficialImageFromUrl(url: URL, key: String) {
        let size = UIScreen.main.bounds
        let smallRect = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height / 2)

        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .replaceError(with: UIImage())
            .replaceEmpty(with: UIImage())
            .replaceNil(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] image in
                guard let self = self else { return }
                if image == UIImage() { return }
                let rect = AVMakeRect(aspectRatio: image.size, insideRect: smallRect)
                guard let smallImage = image.resizedImage(for: rect.size) else { return }
                self.imageCache.set(forKey: key, image: smallImage)
                self.displayImage = smallImage
            })
            .store(in: &cancellables)
    }
    
    private func loadFrontDefaultUrl(from urlString: String) {
        let size = UIScreen.main.bounds
        let smallRect = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height / 2)
        let imageId = StringHelper.getImageId(from: urlString)
        let frontUrl = String(format: Constants.baseFrontImageUrl, "\(imageId)")
        
        guard let url = URL(string: frontUrl) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .replaceError(with: UIImage())
            .replaceEmpty(with: UIImage())
            .replaceNil(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] image in
                if image == UIImage() { return }
               
                let rect = AVMakeRect(aspectRatio: image.size, insideRect: smallRect)
                guard let smallImage = image.resizedImage(for: rect.size) else { return }
                
                self?.imageCache.set(forKey: urlString, image: smallImage)
                self?.displayImage = smallImage
            })
            .store(in: &cancellables)
    }
}

class ImageCache {
    var cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func get(forKey: String) -> UIImage? {
        return cache.object(forKey: NSString(string: forKey))
    }
    
    func set(forKey: String, image: UIImage) {
        cache.setObject(image, forKey: NSString(string: forKey))
    }
}

extension ImageCache {
    private static var imageCache = ImageCache()
    static func getImageCache() -> ImageCache {
        return imageCache
    }
}
