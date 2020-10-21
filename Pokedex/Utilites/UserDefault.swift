//
//  UserDefault.swift
//  Pokedex
//
//  Created by Bui Quang Tri on 10/21/20.
//

import Foundation

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

enum Keys: String {
    case firstTimeOpenApp
    case pokemonsCount
}

final class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(Keys.firstTimeOpenApp.rawValue, defaultValue: true)
    var firstTimeOpenApp: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(Keys.pokemonsCount.rawValue, defaultValue: 0)
    var pokemonsCount: Int {
        willSet {
            objectWillChange.send()
        }
    }
}
