//
//  Task.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import Foundation

// Modelo de datos
struct DataTask: Codable, Identifiable {
    var id: Int? // No es necesario establecerlo
    var title: String
    var details: String
    var priority: Priority
    var date: Date
    var completed: Bool
}
