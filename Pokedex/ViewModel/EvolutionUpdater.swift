//
//  EvolutionUpdater.swift
//  Pokedex
//
//  Created by TriBQ on 10/10/2020.
//

import Foundation
import Combine

struct EvoLink: Identifiable {
    var id = UUID().uuidString
    var from: NamedAPIResource
    var to: NamedAPIResource
    var detail: [EvolutionDetail]
    var triggers: String
}

class EvolutionUpdater: ObservableObject {
    init() {
        mergeResult()
    }
    
    @Published var species: Species? {
        didSet {
            getEvolutionInformation()
        }
    }

    @Published private var evolution: Evolution = Evolution() {
        didSet {
            evolutionChains = evolution.allChains
        }
    }
    
    @Published private var evolutionChains: [EvolutionChain] = [] {
        didSet {
            var links: [EvoLink] = []
            for (index, element) in evolutionChains.enumerated() {
                let fromPokemon = element.species
                if let nextElement = evolutionChains[safe: index + 1] {
                    let toPokemon = nextElement.species
                    let detail = nextElement.evolutionDetails
                    links.append(EvoLink(from: fromPokemon, to: toPokemon, detail: detail, triggers: getTriggerString(from: detail)))
                }
            }
            evolutionLinks = links
        }
    }

    @Published private var evolutionLinks: [EvoLink] = []
    @Published private var megaEvolutionLinks: [EvoLink] = []
    @Published var evolutionSectionsModels: [SectionModel<EvoLink>] = []

    @Published var error: ApiError = .non

    private var cancellables = Set<AnyCancellable>()
    
    private func mergeResult() {
        Publishers.CombineLatest($evolutionLinks, $megaEvolutionLinks)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink { [weak self] (evolutionLinks, megaEvolutionLinks) in
                guard let self = self else { return }
                if evolutionLinks.isEmpty { return }
                var evolutionSectionsModels: [SectionModel<EvoLink>] = []
                evolutionSectionsModels.append(SectionModel(isExpanded: true, title: "Evolution Chain", data: evolutionLinks))
                if !megaEvolutionLinks.isEmpty {
                    evolutionSectionsModels.append(SectionModel(isExpanded: true, title: "Mega Evolution", data: megaEvolutionLinks))
                }
                self.evolutionSectionsModels = evolutionSectionsModels
            }.store(in: &cancellables)
    }
    
    private func getEvolutionInformation() {
        if let megas = species?.megas {
            megaEvolutionLinks = megas.map({EvoLink(from: species?.pokemon ?? NamedAPIResource(), to: $0, detail: [], triggers: "Mega")})
        }
        initEvolution(of: species?.evolutionChain?.url ?? "")
    }
    
    private func initEvolution(of url: String) {
        Session.share.evolution(from: url)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
            .sink(receiveCompletion: { [weak self] complete in
                guard let self = self else { return }
                switch complete {
                case .finished: self.error = .non
                case .failure(let message): self.error = .internet(message: message.localizedDescription)
                }
            }, receiveValue: { [weak self] result in
                guard let self = self else { return }
                self.evolution = result
            })
            .store(in: &cancellables)
    }

    private func getTriggerString(from details: [EvolutionDetail]) -> String {
        guard let mainTrigger = details.first else {
            return ""
        }
        
        switch mainTrigger.evolutionTrigger {
        case .level:
            if let level = mainTrigger.minLevel {
                return "Level \(level)"
            }
            return "Unknow"
        case .trade:
            return "Trade"
        case .item:
            if let item = mainTrigger.heldItem?.name {
                return item
            }
            return "Unknow"
        case .shed:
            return "Shed"
        }
    }
}
