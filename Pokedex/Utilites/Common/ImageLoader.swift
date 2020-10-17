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
    private var cancellable: AnyCancellable?
    var imageCache = ImageCache.getImageCache()
    var url: String

    deinit {
        cancel()
    }
    
    init(url: String) {
        self.url = url
        cancellable = loadImage(from: url).assign(to: \.displayImage, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func loadImage(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        if let image = imageCache.get(forKey: urlString)  {
            return Just(image).eraseToAnyPublisher()
        }

        guard let url = URL(string: urlString) else {
            return Just(nil).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image = image else { return }
                self?.imageCache.set(forKey: urlString, image: image)
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
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
