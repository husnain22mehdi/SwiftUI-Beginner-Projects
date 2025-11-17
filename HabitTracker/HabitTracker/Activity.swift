//
//  Activity.swift
//  HabitTracker
//
//  Created by Husnain on 30/10/2025.
//

import Foundation

struct Activity : Codable, Identifiable, Equatable {
      
    let id : UUID
    var title : String
    var description : String
    
    
}
