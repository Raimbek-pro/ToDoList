//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 30.05.2025.
//
import SwiftUI

struct AddTaskView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""

    var onSave: (_ title: String, _ description: String) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                TextField("Заголовок", text: $title)
                    .font(.system(size: 28, weight: .bold))
                    .padding(.horizontal)
                    .padding(.top)

                Divider()

                TextEditor(text: $description)
                    .font(.body)
                    .padding(.horizontal)
                    .frame(minHeight: 200)

                Spacer()
            }
        }
        .background(Color(.systemBackground))
        .navigationTitle("Новая задача")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Отмена") {
                    dismiss()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Сохранить") {
                    onSave(title, description)
                    dismiss()
                }
                .disabled(title.isEmpty)
                .bold()
            }
        }
    }
}
