//
//  Priority.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import Foundation
import SwiftUI

public enum Priority: Int, Codable, Sendable, CaseIterable {
    case none = 0
    case low = 1
    case medium = 2
    case high = 3

    var text: String {
        switch self {
        case .high: return "Prioridad 1"
        case .medium: return "Prioridad 2"
        case .low: return "Prioridad 3"
        case .none: return "Prioridad 4"
        }
    }

    var color: Color {
        switch self {
        case .high: return .red.opacity(0.8)
        case .medium: return .orange.opacity(0.8)
        case .low: return .blue.opacity(0.8)
        case .none: return .gray.opacity(0.8)
        }
    }
}
