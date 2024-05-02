//
//  Defaults.swift
//  test_movieList
//
//  Created by User on 02.02.2024.
//

import Foundation

private enum DefaultsKey: String {
    case firstInitialization = "firstInitialization"
    case didShowTap = "didShowTap"
}

final class Defaults {
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Data
    
    static var firstInitialization: Bool {
        set{
            _set(value: newValue, key: .firstInitialization)
        } get {
            return _get(valueForKay: .firstInitialization) as? Bool ?? true
        }
    }
    
    static var didShowTap: Bool {
        set {
            _set(value: newValue, key: .didShowTap)
        }
        get {
            return _get(valueForKay: .didShowTap) as? Bool ?? true
        }
    }
    
    // MARK: - Setter and Getter
    
    private static func _set(value: Any?, key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }

    private static func _get(valueForKay key: DefaultsKey) -> Any? {
        return UserDefaults.standard.value(forKey: key.rawValue)
    }
}
