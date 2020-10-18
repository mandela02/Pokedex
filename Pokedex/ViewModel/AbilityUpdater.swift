//
//  AbilityHelper.swift
//  Pokedex
//
//  Created by TriBQ on 19/10/2020.
//

import Foundation
import Combine

class AbilityUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()

    init(name: String) {
        self.name = name
    }
    @Published var name: String = "" {
        didSet {
            url = UrlType.getAbilityUrl(of: name)
        }
    }

    @Published var url: String = "" {
        didSet {
            getAbility(from: url)
        }
    }
    
    @Published var ability: Ability = Ability() {
        didSet {
            if let titles = ability.flavorTextEntries, !titles.isEmpty {
                title = StringHelper.getEnglishText(from: titles)
            }
            if let descriptions = ability.effectEntries, !descriptions.isEmpty {
                description = StringHelper.getEnglishText(from: descriptions)
            }
        }
    }
    
    @Published var title: String = ""
    @Published var description: String = ""

    private func getAbility(from url: String) {
        guard !url.isEmpty else { return }
        Session.share.ability(from: url)
            .replaceError(with: Ability())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .assign(to: \.ability, on: self)
            .store(in: &cancellables)
    }
}
