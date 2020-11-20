//
//  RegionDetailUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 20/11/2020.
//

import Foundation
import Combine
class RegionDetailUpdater: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    var url: String? {
        didSet {
            getRegion(from: url)
        }
    }
    @Published var region: Region?
    @Published var selectedLocation: String = ""

    func getRegion(from url: String?) {
        guard let url = url else { return }
        Session.share.region(from: url)
            .replaceError(with: Region())
            .receive(on: DispatchQueue.main)
            .sink { region in
                self.region = region
            }.store(in: &cancellables)
    }
}
