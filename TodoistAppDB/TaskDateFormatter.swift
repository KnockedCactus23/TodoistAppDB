//
//  TaskDateFormatter.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

// Estructura para formatear la fecha
struct TaskDateFormatter {
    static func formattedString(for date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        // Si la entrega es hoy, se coloca hoy
        if calendar.isDate(date, inSameDayAs: now) {
            return "Hoy"
        // Si la entrega es dentro de una semana, se coloca el día de la semana
        } else if let weekFromNow = calendar.date(byAdding: .day, value: 7, to: now),
                  date < weekFromNow {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date)
        } else {
            // Si la entrega es más lejos de una semana, se coloca día y mes
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            return formatter.string(from: date)
        }
    }
    
    // Función que asigna un color a cada formato de fecha
    static func color(for date: Date) -> Color {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDate(date, inSameDayAs: now) {
            return .green
        } else if let weekFromNow = calendar.date(byAdding: .day, value: 7, to: now),
                  date < weekFromNow {
            return .brown
        } else {
            return .gray.opacity(0.8)
        }
    }
}
