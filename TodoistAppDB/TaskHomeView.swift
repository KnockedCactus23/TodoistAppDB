//
//  TaskHomeView.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

struct TaskHomeView: View {
    
    @State private var tasks: [DataTask] = []
    @State private var showingCreateView = false
    @State private var selectedTask: DataTask? = nil
    
    // Manejo de errores
    @State private var errorMessage: String?
    @State private var showErrorAlert = false
    @State private var isLoading = false
    
    private let taskService = TaskService() // Servicio para interactuar con la API
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Fondo
                LinearGradient(
                    colors: [.white, .red.opacity(0.3)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            
                // Si las tareas están vacías, se muestra que no hay tareas por hacer
                if isLoading{
                    ProgressView("Cargando tareas...")
                        .progressViewStyle(.circular)
                        .tint(.red)
                } else if tasks.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80))
                            .foregroundStyle(.red)
                            .opacity(0.7)
                        
                        Text("¡No hay tareas aún!\nDisfruta de tu día 😃")
                            .font(.title3)
                            .foregroundColor(.gray)
                            .bold()
                    }
                } else {
                    // Se muestran en orden las tareas por hacer
                    List {
                        ForEach(tasks) { task in
                            TaskListView(task: task){
                                Task {
                                    await deleteTask(task)
                                }
                            }
                                .listRowBackground(Color.clear)
                                // Controla la vista de edición al hacer clic en la tarea
                                .onTapGesture {
                                    selectedTask = task
                                }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                
                // Botón para agregar más tareas
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            showingCreateView = true
                        }) {
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationTitle("Mis Tareas")
            .task { await loadTasks() } // Se cargan las tareas al iniciar la vista

            .sheet(isPresented: $showingCreateView) {
                TaskCreateView()
                    .presentationDetents([.medium, .height(500)])
                    .presentationDragIndicator(.visible)
                    .onDisappear { Task { await loadTasks() } } // Recarga las tareas después de crear
            }
            
            // Activar vista de edición
            .sheet(item: $selectedTask) { taskToEdit in
                TaskEditView(task: taskToEdit)
                    .presentationDetents([.height(350), .medium])
                    .presentationDragIndicator(.visible)
                    .onDisappear { Task { await loadTasks() } } // Recarga las tareas después de editar
            }
            
            // Manejo de errores
            .alert(isPresented: $showErrorAlert) {
                Alert(
                    title: Text("¡Oops!"),
                    message: Text(errorMessage ?? "Ha ocurrido un error"),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Función para cargar las tareas
    private func loadTasks() async {
        isLoading = true
        do {
            tasks = try await taskService.fetchTasks() // Llama al servicio para obtener las tareas
        } catch {
            errorMessage = "Error cargando tareas: \(error.localizedDescription)"
            showErrorAlert = true
        }
        isLoading = false
    }

    // Función para borrar tareas
    private func deleteTask(_ task: DataTask) async {
        guard let id = task.id else { return }
        do {
            try await taskService.deleteTask(id: id) // Llama al servicio para borrar las tareas
            await loadTasks() // Se cargan de nuevo las tareas
        } catch {
            errorMessage = "Error eliminando la tarea: \(error.localizedDescription)"
            showErrorAlert = true
        }
    }
}

#Preview{
    TaskHomeView()
}
