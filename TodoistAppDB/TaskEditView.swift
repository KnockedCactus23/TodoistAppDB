//
//  TaskEditView.swift
//  TodoistAppDB
//
//  Created by Sergio Rodríguez Pérez on 29/10/25.
//

import SwiftUI
struct TaskEditView: View {
    
    @State var task : DataTask
    
    // Pop-ups
    @State private var showEditPopup = false
    @State private var showDatePicker = false
    @State private var showPriorityPicker = false
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            // Titulo y Prioridad
            HStack{
                Circle()
                    .fill(task.priority.color)
                    .overlay(Circle().stroke(style: StrokeStyle(lineWidth: 1)))
                    .frame(width: 25, height: 25)
                Text(task.title)
                    .font(.title2)
                    .bold()
                    .onTapGesture{
                        showEditPopup = true
                    }
                Spacer()
            }
            
            // Descripción
            Label(task.details, systemImage: "text.alignleft")
                .font(.title3)
                .onTapGesture{
                    showEditPopup = true
                }
            
            Divider()
            
            // Fecha
            HStack{
                Image(systemName: "calendar")
                    .font(.title3)
                    .foregroundColor(TaskDateFormatter.color(for: task.date))
                    .onTapGesture{
                        showDatePicker = true
                    }

                Text(TaskDateFormatter.formattedString(for: task.date))
                    .font(.title3)
                    .onTapGesture{
                        showDatePicker = true
                    }
                Spacer()
            }
            
            Divider()
            
            // Prioridad
            HStack{
                Image(systemName: "flag.fill")
                    .font(.title3)
                    .foregroundColor(task.priority.color)
                    .onTapGesture{
                        showPriorityPicker = true
                    }

                Text(task.priority.text)
                    .font(.title3)
                    .onTapGesture{
                        showPriorityPicker = true
                    }
                Spacer()
            }
            Spacer()
        }
        .padding()
        .padding(.horizontal, 5)
        .padding(.top, 30)
        
        // Pop-ups
        .sheet(isPresented: $showEditPopup) {
            EditTaskPopup(task: $task)
        }
        .sheet(isPresented: $showDatePicker) {
            DatePickerPopup(task: $task)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPriorityPicker) {
            PriorityPickerPopup(currentTask: $task)
                .presentationDetents([.height(300)])
                .presentationDragIndicator(.visible)
        }
        .padding(.horizontal)
        
    }
}

#Preview {
    TaskEditView(task: DataTask(title: "MobileActivity08", details: "Tarea de Software", priority: .low, date: Date(), completed: false))
}
