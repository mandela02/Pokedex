//
//  AbilityHelper.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
//

import Foundation
import Combine

struct SelectedAbilityModel {
    var name: String
    var description: String
}

class AbilityUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    var pokemon = Pokemon() {
        didSet {
            if pokemon.isEmpty { return }
            getAllAbilities(from: pokemon)
        }
    }
    @Published private var abilities: [Ability] = [] {
        didSet {
            isLoading = false
            names = abilities.compactMap({$0.name}).map({$0.capitalizingFirstLetter()})
        }
    }
    
    @Published var error: ApiError = .non
    @Published var selectedString: String? {
        didSet {
            guard let selectedString = selectedString else { return }
            let selectedName = selectedString
            let selectedDescripton = abilities.first(where: {$0.name == selectedString.lowercased()}).map({StringHelper.getEnglishText(from: $0.effectEntries ?? [])}) ?? ""
            selectedAbility = SelectedAbilityModel(name: selectedName, description: selectedDescripton)
        }
    }

    @Published var selectedAbility: SelectedAbilityModel?
    @Published var names: [String] = []

    var isLoading = true
    
    func onTap(of text: String) {
        if text == selectedString {
            selectedString = nil
        } else {
            selectedString = text
        }
    }
    
    private func getAllAbilities(from pokemon: Pokemon) {
        guard let abilities = pokemon.abilities else { return }
        Publishers.MergeMany(abilities.map({Session.share.ability(from: UrlString.getAbilityUrl(of: $0.ability.name))}))
            .collect()
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let error):
                    self.isLoading = false
                    self.error = .internet(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.abilities = result
            })
            .store(in: &cancellables)
    }
}
