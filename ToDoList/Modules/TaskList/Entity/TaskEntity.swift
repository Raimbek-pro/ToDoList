//
//  TaskEntity.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import Foundation


struct TaskEntity: Identifiable {
    let id: Int64
    var title: String
    var description: String
    var creationDate: Date
    var isCompleted: Bool
}
