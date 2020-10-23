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
    private var cancellable: AnyCancellable?
    var imageCache = ImageCache.getImageCache()
    var url: String

    deinit {
        cancel()
    }
    
    init(url: String) {
        self.url = url
        loadImage(from: url)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func loadImage(from urlString: String) {
        if let image = imageCache.get(forKey: urlString)  {
            displayImage = image
        }

        guard let url = URL(string: urlString) else {
            return
        }
        
        let size = UIScreen.main.bounds
        let smallRect = CGRect(x: 0, y: 0, width: size.width / 2, height: size.height / 2)
        
        self.cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .replaceError(with: UIImage())
            .replaceEmpty(with: UIImage())
            .replaceNil(with: UIImage())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveValue: { [weak self] image in
                let rect = AVMakeRect(aspectRatio: image.size, insideRect: smallRect)
                guard let smallImage = image.resizedImage(for: rect.size) else { return }
                self?.imageCache.set(forKey: urlString, image: smallImage)
                self?.displayImage = smallImage
            })
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
