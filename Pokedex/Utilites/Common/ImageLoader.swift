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
    
    deinit {
        cancel()
    }
    
    init(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        cancellable = loadImage(from: url).assign(to: \.displayImage, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func loadImage(from url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = ImageCache.share[url] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: { image in
                guard let image = image else { return }
                ImageCache.share[url] = image
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
