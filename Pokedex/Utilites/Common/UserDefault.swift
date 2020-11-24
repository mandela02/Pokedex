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

    init(key: String, defaultValue: T) {
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
    case speciesCount
    case isDarkMode
}

struct Settings {
    static var isDarkMode = UserDefault<Bool>(key: Keys.isDarkMode.rawValue, defaultValue: false)
}

final class UserSettings: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault(key: Keys.firstTimeOpenApp.rawValue, defaultValue: true)
    var firstTimeOpenApp: Bool {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(key: Keys.pokemonsCount.rawValue, defaultValue: 0)
    var pokemonsCount: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(key: Keys.speciesCount.rawValue, defaultValue: 0)
    var speciesCount: Int {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefault(key: Keys.isDarkMode.rawValue, defaultValue: false)
    var isDarkMode: Bool {
        willSet {
            objectWillChange.send()
        }
    }
}
