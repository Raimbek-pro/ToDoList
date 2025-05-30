import SwiftUI

struct TaskListView<T: TaskListPresenterProtocol>: View {
    @ObservedObject var presenter: T
    @State private var showingAddTask: Bool = false
    @State private var selectedTask: TaskEntity?

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(presenter.tasks) { task in
                            VStack(alignment: .leading, spacing: 8) {
                                Text(task.title)
                                    .font(.title3)
                                    .foregroundColor(.white)
                                
                                Text(task.description)
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                Text(formattedDate(task.creationDate))
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            .multilineTextAlignment(.leading)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, minHeight: 75, alignment: .leading)
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
                                        Label("Edit", systemImage: "pencil")
                                    }

                                    Button(role: .destructive, action: {
                                        presenter.deleteTask(id: task.id)
                                    }) {
                                        Label("Delete", systemImage: "trash")
                                    }
                                } else {
                                    Text("можно ред. и удалять только локальные задачи :)")
                                }
                            }
                        }
                    }
                    .padding(.top, 50)
                }
                .navigationTitle("Задачи")
                .navigationBarTitleDisplayMode(.large)
                .onAppear {
                    presenter.onAppear()
                }

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
            .navigationDestination(item: $selectedTask) { task in
                TaskEditView(task: task) { updatedTitle, updatedDescription, updatedIsCompleted in
                    presenter.updateTask(id: task.id, newTitle: updatedTitle, newDescription: updatedDescription, newIsCompleted: updatedIsCompleted)
                }
            }
        }
        .accentColor(.white)
    }

    func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

extension TaskEntity: Hashable {
    static func == (lhs: TaskEntity, rhs: TaskEntity) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
