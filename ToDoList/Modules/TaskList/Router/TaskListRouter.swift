//
//  TaskListRouter.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import SwiftUI
struct TaskListRouter{
    static func build() -> some View {
        let interactor = TaskListInteractor()
        let presenter = TaskListPresenter(interactor: interactor)
        return TaskListView(presenter:  presenter)
    }
}
