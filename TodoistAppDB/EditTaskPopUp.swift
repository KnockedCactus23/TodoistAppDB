//
//  EditTaskPopUp.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

struct EditTaskPopup: View {
    
    @Environment(\.dismiss) private var dismiss
    @Binding var task: DataTask
    
    let taskService = TaskService()
    
    // Variables de titulo y descripción temporales
    @State private var tempTitle: String
    @State private var tempDetails: String
    
    // Mensajes y alertas de error
    @State private var errorMessage: String?
    @State private var showErrorAlert = false
    
    // Inicializador
    init(task: Binding<DataTask>) {
        _task = task
        _tempTitle = State(initialValue: task.wrappedValue.title)
        _tempDetails = State(initialValue: task.wrappedValue.details)
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
             
                VStack(alignment: .leading, spacing: 20){
                    // Titulo de la tarea
                    HStack {
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 20, height: 20)
                            .opacity(0.4)
                        
                        TextField("Nombre de la tarea", text: $tempTitle)
                            .textFieldStyle(.plain)
                            .font(.title3)
                            .foregroundColor(.primary)
                    }
                    
                    // Descripción de la tarea
                    HStack {
                        Image(systemName: "text.alignleft")
                            .foregroundColor(.gray)
                        
                        TextField("Descripción", text: $tempDetails)
                            .textFieldStyle(.plain)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                    }
                    Spacer()
                }
                .padding(.top, 30)
                .padding(.horizontal, 30)
                .navigationTitle("Editar Tarea")
                .navigationBarTitleDisplayMode(.inline)
                
                // Botones de guardar y cancelar
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancelar") { dismiss() }
                            .tint(.red)
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Guardar") {
                            // Si no existe, solo actualizamos localmente
                            if task.id == nil {
                                task.title = tempTitle
                                task.details = tempDetails
                                dismiss()
                            } else {
                                // Si existe, se actualiza en la base de datos a través de la API
                                Task {
                                    do {
                                        var updatedTask = task
                                        updatedTask.title = tempTitle
                                        updatedTask.details = tempDetails
                                        
                                        _ = try await taskService.updateTask(updatedTask) // Llamada a la API
                                        task = updatedTask
                                        dismiss()
                                    } catch {
                                        errorMessage = "Error al actualizar la tarea: \(error.localizedDescription)"
                                        showErrorAlert = true
                                    }
                                }
                            }
                        }
                        .tint(.red)
                        .disabled(!TaskCreateView.isValidName(tempTitle)) // Deshabilita la opción de guardar si el nombre no es válido
                    }
                }
                // Muestra el error al usuario
                .alert(isPresented: $showErrorAlert) {
                    Alert(
                        title: Text("¡Oops!"),
                        message: Text(errorMessage ?? "Ha ocurrido un error"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}
