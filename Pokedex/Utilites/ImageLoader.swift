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
    private let cache = ImageCache()
    private var cancellable: AnyCancellable?

    deinit {
        cancellable?.cancel()
    }
    
    init(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        cancellable = loadImage(from: url).assign(to: \.displayImage, on: self)
    }
    
    func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[weak self] image in
                guard let image = image else { return }
                self?.cache[url] = image
            })
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
