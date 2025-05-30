//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 30.05.2025.
//
import SwiftUI
struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title = ""
    @State private var description = ""
    
    var onSave: (_ title: String, _ description: String) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Название")) {
                    TextField("Введите заголовок", text: $title)
                }
                Section(header: Text("Описание")) {
                    TextField("Введите описание", text: $description)
                }
            }
            .navigationBarTitle("Новая задача", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Отмена") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Сохранить") {
                    onSave(title, description)
                    presentationMode.wrappedValue.dismiss()
                }.disabled(title.isEmpty)
            )
        }
    }
}
