//
//  Settings.swift
//  Habits
//
//  Created by Олег Бабыр on 07.08.2021.
//

import Foundation
 

struct Settings {
    static var shared = Settings()
    
    private let defaults = UserDefaults.standard
    
    enum Setting {
        static let favoriteHabits = "favoriteHabits"
    }
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
              let data = string.data(using: .utf8) else {
            return nil
        }
        
        return try! JSONDecoder().decode(T.self, from: data)
    }
    
    var favoriteHabits: [Habit] {
        get {
            return unarchiveJSON(key: Setting.favoriteHabits) ?? []
        }
        set {
            archiveJSON(value: newValue, key: Setting.favoriteHabits)
        }
    }
}
