//
//  DatePickerPopUp.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

struct DatePickerPopup: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var task: DataTask // Referencia a task
    @State private var tempDate: Date // Variable temporal de la fecha
    
    let taskService = TaskService()
    
    // Inicializador
    init(task: Binding<DataTask>) {
        _task = task
        _tempDate = State(initialValue: task.wrappedValue.date)
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                // Fondo
                LinearGradient(
                    colors: [.white, .red.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Selector de Fecha
                    DatePicker("", selection: $tempDate, in:Date()..., displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .accentColor(Color(.red))
                        .labelsHidden()
                    Spacer()
                }
                .padding()
                .navigationTitle("Fecha")
                .navigationBarTitleDisplayMode(.inline)
                
                // Botones de guardar y cancelar
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                            .tint(.red)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            if task.id == nil {
                                // Si la tarea no existe, se guarda la modificación localmente
                                task.date = tempDate
                                dismiss()
                            } else {
                                // Si la tarea existe, se actualiza en la base de datos a través de la API
                                Task {
                                    do {
                                        var updatedTask = task
                                        updatedTask.date = tempDate
                                        _ = try await taskService.updateTask(updatedTask) // Se llama a la API
                                        task = updatedTask
                                        dismiss()
                                    } catch {
                                        print("Error al actualizar la tarea: \(error)")
                                    }
                                }
                            }
                        }
                            .tint(.red)
                    }
                }
            }
        }
    }
}
