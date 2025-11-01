//
//  TaskListView.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI

struct TaskListView: View {
    var task : DataTask
    var onDelete: () -> Void
    
    // Controla la animación
    @State private var animate = false
    @State private var showCheck = false
    
    var body: some View {
        HStack (alignment: .top, spacing: 12) {
            // Botón de Prioridad, servirá para eliminar tareas
            Button(action: {
                completeAndDeleteAnimation()
            }){
                ZStack{
                    Circle()
                        .fill(task.priority.color)
                        .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)))
                        .frame(width: 20, height: 20)
                        .padding(.top, 2)
                        .scaleEffect(animate ? 1.2 : 1.0)
                    
                    if showCheck{
                        Circle()
                            .fill(task.priority.color)
                            .frame(width: 20, height: 20)
                            .padding(.top, 2)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                            .transition(.scale)
                    }
                }
            }
            .buttonStyle(.plain)
            
            VStack (alignment: .leading, spacing: 6){
                // Titulo de la tarea
                Text(task.title)
                    .font(Font.headline)
                    .foregroundColor(.primary)
                
                // Descripción de la tarea
                Text(task.details)
                    .font(Font.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                // Fecha de vencimiento
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(TaskDateFormatter.color(for: task.date))
                    Text(TaskDateFormatter.formattedString(for: task.date))
                        .font(.caption)
                        .foregroundColor(TaskDateFormatter.color(for: task.date))
                }
            }
            Spacer()
        }
        .animation(.spring(), value: animate)
        .animation(.easeInOut, value: showCheck)
    }
    
    // Función de animación y eliminación con delay
    private func completeAndDeleteAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
            animate = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation {
                showCheck = true
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation {
                onDelete()
            }
        }
    }
}
