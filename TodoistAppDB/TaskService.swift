//
//  TaskService.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import Foundation

class TaskService {
    private let baseURL = "http://localhost:8001/api/tasks"
    
    // Función para obtener todas las tareas
    func fetchTasks() async throws -> [DataTask] {
        let url = URL(string: baseURL)! // URL base
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Código HTTP:", httpResponse.statusCode)
        }
        print("Datos recibidos:", String(data: data, encoding: .utf8) ?? "nil")
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601  // Para decodificar lo obtenido de la base de datos
        
        return try decoder.decode([DataTask].self, from: data)
    }

    // Función para crear una tarea
    func createTask(_ task: DataTask) async throws -> DataTask {
        let url = URL(string: baseURL)! // URL base para la API
        
        // Configurar la petición HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Configuración del encoder
        let encoder = JSONEncoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd" // Formato de fecha compatible con PostgreSQL
        encoder.dateEncodingStrategy = .formatted(formatter)
        
        // Convertir la tarea a JSON
        request.httpBody = try encoder.encode(task)
        
        print("Body enviado:", String(data: request.httpBody!, encoding: .utf8) ?? "nil")
        
        // Enviar la solicitud al servidor de manera asíncrona
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Código HTTP:", httpResponse.statusCode)
        }
        print("Respuesta:", String(data: data, encoding: .utf8) ?? "nil")
        
        // Decoder con formato ISO8601 para la respuesta recibida
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(DataTask.self, from: data)
    }

    // Función para actualizar una tarea
    func updateTask(_ task: DataTask) async throws -> DataTask {
        guard let id = task.id else { throw URLError(.badURL) }
        let url = URL(string: "\(baseURL)/\(id)")! // URL base con id para la API
        
        // Configuración de la petición HTTP
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Configuración del codificador con formato de fecha ISO 8601
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(task)
        
        print("Actualizando tarea en:", url)
        print("Body:", String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "nil")
        
        // Envío de la solicitud al servidor
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("Código HTTP:", httpResponse.statusCode)
        }
        print("Respuesta:", String(data: data, encoding: .utf8) ?? "nil")
        
        // Configurar decodificador
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return try decoder.decode(DataTask.self, from: data)
    }

    // Función para eliminar una tarea
    func deleteTask(id: Int) async throws {
        let url = URL(string: "\(baseURL)/\(id)")! // URL para la API
        var request = URLRequest(url: url) // Petición HTTP
        request.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: request) // Se realiza la petición
    }
}
