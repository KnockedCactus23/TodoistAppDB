//
//  TodoistAppDBTests.swift
//  TodoistAppDBTests
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import Testing
import Foundation
@testable import TodoistAppDB

struct TodoistAppDBTests {
    
    // Test 1. Comprobar que no guarde tareas sin nombre
    @Test("El nombre no debe estar vacío ni en blanco")
    func testNameValidation() async throws {
        #expect(TaskCreateView.isValidName("Tarea 1"))
        #expect(!TaskCreateView.isValidName(""))
        #expect(!TaskCreateView.isValidName(" "))
    }
    
    // Test 2. Comprobar que el formato de la fecha al codificar sea yyyy-MM-dd
    @Test("El formato de fecha al codificar debe ser yyyy-MM-dd")
    func testDateEncodingFormat() async throws {
        let task = DataTask(
            id: nil,
            title: "Test Fecha",
            details: "Detalles",
            priority: .medium,
            date: Date(timeIntervalSince1970: 0),
            completed: false
        )
        
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        let data = await MainActor.run {
            try! encoder.encode(task)
        }
        
        let jsonString = String(data: data, encoding: .utf8)!
        print("JSON generado:", jsonString)
        
        #expect(jsonString.contains("\"1970-01-01\""))
    }

    // Test 3. Asegurar que la respuesta JSON de la API se decodifique correctamente
    @Test("La respuesta JSON de la API debe decodificarse correctamente")
    func testTaskDecoding() async throws {
        let json = """
        {
            "id": 1,
            "title": "Tarea API",
            "details": "Probando decodificación",
            "priority": 2,
            "date": "2025-11-03T00:00:00.000Z",
            "completed": false
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let task = await MainActor.run {
            try! decoder.decode(DataTask.self, from: json)
        }
        
        #expect(task.id == 1)
        #expect(task.title == "Tarea API")
        #expect(task.priority == .medium)
    }
}
