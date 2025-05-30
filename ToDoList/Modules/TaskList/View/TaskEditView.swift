import SwiftUI

struct TaskEditView: View {
    var task: TaskEntity
    var onSave: (String, String, Bool) -> Void

    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool

    init(task: TaskEntity, onSave: @escaping (String, String, Bool) -> Void) {
        self.task = task
        self.onSave = onSave
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Title", text: $title)
            }
            Section(header: Text("Description")) {
                TextField("Description", text: $description)
            }
            Section {
                Toggle("Completed", isOn: $isCompleted)
            }
        }
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    onSave(title, description, isCompleted)
                }
            }
        }
    }
}
