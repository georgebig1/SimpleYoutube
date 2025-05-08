//
//  UserDefaults+Extension.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/8.
//

import Foundation

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case channel
        case playlist
    }

    func setObject<T: Codable>(_ object: T, forKey key: UserDefaultsKeys) {
        do {
            let data = try JSONEncoder().encode(object)
            self.set(data, forKey: key.rawValue)
            print("\(key) saved to UserDefaults")
        } catch {
            print("Failed to save \(key): \(error)")
        }
    }

    func getObject<T: Codable>(forKey key: UserDefaultsKeys, as type: T.Type) -> T? {
        guard let data = self.data(forKey: key.rawValue) else { return nil }
        do {
            let object = try JSONDecoder().decode(type, from: data)
            print("\(key) loaded from UserDefaults")
            return object
        } catch {
            print("Failed to load \(key): \(error)")
            return nil
        }
    }
}
