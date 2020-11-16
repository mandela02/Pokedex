//
//  ReachabilityUpdater.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 11/2/20.
//

import Foundation
import Combine

class ReachabilityUpdater: ObservableObject {
    @Published var hasNoInternet = false {
        didSet {
            retry = !hasNoInternet
        }
    }
    @Published var retry = false

    private var cancellables = Set<AnyCancellable>()
    
    init() {
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
            hasNoInternet = false
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }

        NotificationCenter.default.publisher(for: .flagsChanged)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.hasNoInternet = false
            }.store(in: &cancellables)
    }
}
