//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import Foundation

protocol TaskListInteractorProtocol {
    func fetchTasks() -> [TaskEntity]
}

class TaskListInteractor: TaskListInteractorProtocol {
    func fetchTasks() -> [TaskEntity] {
        return [
                   TaskEntity(id: 1, title: "Сделать тестовое", description: "Отправить до дедлайна", creationDate: Date(), isCompleted: false),
                   TaskEntity(id: 2, title: "Покрасить волосы", description: "Чтобы пройти мимо красиво", creationDate: Date(), isCompleted: true)
               ]
    }
}
