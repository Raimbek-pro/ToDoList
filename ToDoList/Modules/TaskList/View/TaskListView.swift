import SwiftUI

struct TaskListView<T: TaskListPresenterProtocol>: View {
    @ObservedObject var presenter: T
    @State private var showingAddTask: Bool = false
    @State private var selectedTask: TaskEntity?
    @State private var searchText: String = ""
    @State private var isNavigatingToAddTask: Bool = false
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(spacing: 3) {
                        // Custom header with title and search bar
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Задачи")
                                .font(.system(size: 34, weight: .bold))
                                    .padding(.top, 10)
                            TextField("Поиск", text: $searchText)
                                .padding(8)
                                   .frame(height: 36)
                                   .background(Color(.secondarySystemBackground))
                                   .cornerRadius(10)
                        }
                        .frame(width: 320, height: 90, alignment: .leading)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        // Task list
                        ForEach(
                            presenter.tasks
                                .sorted(by: { $0.creationDate > $1.creationDate }) // Newest first
                                .filter {
                                    searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
                                }
                        ) { task in
                            HStack(alignment: .top, spacing: 1) {
                                Button(action: {
                                    presenter.updateTask(
                                        id: task.id,
                                        newTitle: task.title,
                                        newDescription: task.description,
                                        newIsCompleted: !task.isCompleted
                                    )
                                }) {
                                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        
                                        .foregroundColor(task.isCompleted ? .yellow : .white)
                                      
                                }

                                VStack(alignment: .leading, spacing: 8) {
                                    Text(task.title)
                                       
                                        .font(.system(size: 17, weight: .semibold))
                                                   
                                                   .strikethrough(task.isCompleted, color: .white)
                                                   .foregroundColor(.white)

                                    Text(task.description)
                                    
                                        .font(.system(size: 15))
                                                   
                                                    .strikethrough(task.isCompleted, color: .white)
                                                    .foregroundColor(.white)

                                    Text(formattedDate(task.creationDate))
                                     
                                        .font(.system(size: 13))
                                                  .opacity(0.5)
                                                  .foregroundColor(.white)
                                }
                             
                                .padding(.leading, 20) // padding-left: 20px
                                .padding(.trailing, 20) // padding-right: 20px

                                Spacer()
                            }
                           .padding(.vertical, 12)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)
                            .background(Color(.systemBackground))
                            .overlay(
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.gray),
                                alignment: .bottom
                            )
                            .contextMenu {
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
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    .onAppear {
                        presenter.onAppear()
                    }
                }

                HStack {
                    Spacer()

                    Button(action: {
                        isNavigatingToAddTask = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.clear)
                            .foregroundColor(.yellow)
                            .shadow(radius: 5)
                    }
                    .padding(.trailing, 16)
                    .padding(.vertical, 4)                }
                .frame(maxWidth: .infinity)
                .background(Color(red: 39/255, green: 39/255, blue: 41/255))
                .navigationDestination(isPresented: $isNavigatingToAddTask) {
                    AddTaskView { title, description in
                        presenter.addTask(title: title, taskDescription: description)
                        isNavigatingToAddTask = false
                    }
                }
                                         }
            .navigationDestination(item: $selectedTask) { task in
                TaskEditView(task: task) { updatedTitle, updatedDescription, updatedIsCompleted in
                    presenter.updateTask(
                        id: task.id,
                        newTitle: updatedTitle,
                        newDescription: updatedDescription,
                        newIsCompleted: updatedIsCompleted
                    )
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
