//
//  PriorityPickerPopUp.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

struct PriorityPickerPopup: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var currentTask: DataTask
   
    let taskService = TaskService()
    
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Lista de prioridades disponibles
                ForEach(Priority.allCases.sorted(by: { $0.rawValue > $1.rawValue }), id: \.self) { p in
                    HStack(spacing: 12) {
                        Image(systemName: "flag.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(p.color)
                        
                        Text(p.text)
                            .font(.title3)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Si la prioridad está seleccionada se muestra un checkmark
                        if currentTask.priority == p {
                            Image(systemName: "checkmark")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                    .background(Color.clear)
                    
                    .onTapGesture {
                        // Al hacer clic se selecciona la prioridad indicada
                        currentTask.priority = p
                        
                        // Si la tarea ya fue creada, se llama a la API para actualizarla
                        if currentTask.id != nil {
                            Task {
                                do {
                                    _ = try await taskService.updateTask(currentTask)
                                    dismiss()
                                } catch {
                                    print("Error al actualizar prioridad: \(error)")
                                }
                            }
                        } else {
                            dismiss()
                        }
                        }
                        
                        if p != Priority.allCases.first {
                            Divider()
                                .padding(.leading)
                        }
                    }
                    
                    // Botón de cancelar
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.title2)
                    .background(Color.clear)
                    .foregroundColor(.black)
                    .padding(.top, 20)
                }
                .padding()
            }
        }
    }
