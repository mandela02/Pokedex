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
    
    @Published var pokemonUrl: String? {
        didSet {
            initPokemon()
        }
    }
    
    @Published var pokemon: Pokemon = Pokemon()
    
    @Published var isFinishLoading = false
    @Published var isSelected = false {
        didSet {
            if isSelected {
                currentId = pokemon.pokeId
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var images: [UIImage?] = []
    @Published var ids: [Int] = [] {
        didSet {
            if isSelected {
                loadAlotOfImage()
            }
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
        guard let url = pokemonUrl else { return }
        Session
            .share
            .pokemon(from: url)
            .replaceError(with: Pokemon())
            .receive(on: RunLoop.main)
            .handleEvents(receiveOutput: { [weak self] out in
                self?.isFinishLoading = true
            })
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
    private func loadAlotOfImage() {
        Publishers.Sequence(sequence: ids.map({UrlType.getImageUrlString(of: $0)}).map({loadImage(from: $0)}))
            .flatMap({$0})
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.images, on: self)
            .store(in: &cancellables)
    }
    
    private func loadImage(from url: String) -> AnyPublisher<UIImage?, Never> {
        guard let url = URL(string: url) else {
            return PassthroughSubject<UIImage?, Never>().eraseToAnyPublisher()
        }
        
        if let image = ImageCache.share[url] {
            return Just(image).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
