import SwiftUI

struct TaskEditView: View {
    var task: TaskEntity
    var onSave: (String, String, Bool) -> Void

    @State private var title: String
    @State private var description: String
    @State private var isCompleted: Bool

    
    @Environment(\.dismiss) private var dismiss
    
    init(task: TaskEntity, onSave: @escaping (String, String, Bool) -> Void) {
        self.task = task
        self.onSave = onSave
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _isCompleted = State(initialValue: task.isCompleted)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Title", text: $title)
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top)

                Divider()

                TextEditor(text: $description)
                    .font(.body)
                    .padding(.horizontal)
                    .frame(minHeight: 200) // Adjust height as needed


                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Edit Task")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    onSave(title, description, isCompleted)
                    dismiss()
                }
                .bold()
            }
        }
    }
}
