//
//  PokemonUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 06/10/2020.
//

import Combine
import SwiftUI

class PokemonUpdater: ObservableObject {
    init(url: String) {
        self.pokemonUrl = url
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    var imageCache = ImageCache.getImageCache()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var pokemonUrl: String? {
        didSet {
            initPokemon()
        }
    }
    
    @Published var pokemon: Pokemon = Pokemon() {
        didSet {
            updateCurrentId(of: pokemon)
        }
    }
    
    @Published var isSelected = false
    
    @Published var preLoadImages: [UIImage?] = []
    
    @Published var images: [String] = []
    @Published var ids: [Int] = [] {
        didSet {
            //loadAlotOfImage()
            images = ids.map({UrlType.getImageUrlString(of: $0)})
        }
    }
    
    @Published var currentId: Int = 0 {
        didSet {
            if currentId > 0 {
                ids = [currentId - 1, currentId, currentId + 1]
            }
        }
    }
    
    private func initPokemon() {
        guard let url = pokemonUrl, !url.isEmpty else { return }
        print(url)
        Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.pokemon, on: self)
            .store(in: &cancellables)
    }
    
    func update(onSuccess: () -> ()) {
        let nextUrl = UrlType.getPokemonUrl(of: currentId)
        if pokemonUrl != nextUrl {
            pokemonUrl = nextUrl
            onSuccess()
        }
    }
}

extension PokemonUpdater {
    private func updateCurrentId(of pokemon: Pokemon) {
        if currentId != pokemon.pokeId {
            currentId = pokemon.pokeId
        }
    }
    private func loadAlotOfImage() {
        Publishers.Sequence(sequence: ids.map({UrlType.getImageUrlString(of: $0)}).map({loadImage(from: $0)}))
            .flatMap({$0})
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.preLoadImages, on: self)
            .store(in: &cancellables)
    }
    
    private func loadImage(from urlString: String) -> AnyPublisher<UIImage?, Never> {
        if let image = imageCache.get(forKey: urlString) {
            return Just(image).eraseToAnyPublisher()
        }
        
        guard let url = URL(string: urlString) else {
            return PassthroughSubject<UIImage?, Never>().eraseToAnyPublisher()
        }
                
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [weak self] image in
                guard let image = image else { return }
                self?.imageCache.set(forKey: urlString, image: image)
            })
            .eraseToAnyPublisher()
    }
}
