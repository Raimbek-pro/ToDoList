//
//  TaskListView.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//
import SwiftUI

struct TaskListView<T: TaskListPresenterProtocol>: View {
    @ObservedObject var presenter: T
    @State var showingAddTask: Bool = false
    @State private var selectedTask: TaskEntity?
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            NavigationView {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(presenter.tasks) { task in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(task.title)
                                    .font(.title3)
                                    .foregroundColor(.white) // Set text color to white
                                
                                Text(task.description)
                                    .font(.body)
                                    .foregroundColor(.white) // Set text color to white
                                
                                Text(formattedDate(task.creationDate))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, minHeight: 75, alignment: .leading) // Fixed size
                            .background(Color(.systemBackground))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray),
                                alignment: .bottom
                            )
                            .contextMenu {
                                if task.isLocal {
                                    Button(action: {
                                        selectedTask = task
                                    }) {
                                        Text("Edit")
                                        Image(systemName: "pencil")
                                    }

                                    Button(role: .destructive, action: {
                                        presenter.deleteTask(id: task.id)
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                } else {
                                    Text("можно ред. и удалять только локальные задачи :)")
                                }
                            }
                        }
                    }
                    .padding(.top, 50) // Top offset
                }
                .navigationTitle("Задачи")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    presenter.onAppear()
                }
            }
            .accentColor(.white)
            
            Button(action: {
                showingAddTask = true
            }) {
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 24))
                    .padding()
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
            .sheet(isPresented: $showingAddTask) {
                AddTaskView { title, description in
                    presenter.addTask(title: title, taskDescription: description)
                }
            }
        }
        .sheet(item: $selectedTask) { task in
            TaskEditView(task: task) { updatedTitle, updatedDescription, updatedIsCompleted in
                presenter.updateTask(id: task.id, newTitle: updatedTitle, newDescription: updatedDescription, newIsCompleted: updatedIsCompleted)
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
