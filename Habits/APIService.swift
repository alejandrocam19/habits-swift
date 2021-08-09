//
//  APIService.swift
//  Habits
//
//  Created by Олег Бабыр on 31.07.2021.
//

import Foundation

struct HabitRequest: APIRequest {
    
    typealias Response = [String: Habit]
    
    var habitName: String?
    
    var path: String { "/habits" }
}
