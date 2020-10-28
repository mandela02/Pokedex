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
            isLoadingData =  true
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
            isLoadingData = false
        }
    }
    
    @Published var title = ""
    @Published var description = ""
    @Published var isLoadingData = true
    @Published var error: ApiError = .non

    private func getAbility(from url: String) {
        guard !url.isEmpty else { return }
        Session.share.ability(from: url)
            .replaceError(with: Ability())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished:
                    self.error = .non
                case .failure(let error):
                    self.isLoadingData = false
                    self.error = .internet(message: error.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.ability = result
            })
            .store(in: &cancellables)
    }
}
