//
//  TaskListPresenter.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import Foundation
import Combine

protocol TaskListPresenterProtocol: ObservableObject {
    var tasks: [TaskEntity] { get }
    func onAppear()
}

class TaskListPresenter: TaskListPresenterProtocol,ObservableObject {
    @Published var tasks: [TaskEntity] = []
    private let interactor : TaskListInteractorProtocol
    init(interactor: TaskListInteractorProtocol) {
          self.interactor = interactor
      }
    func onAppear() {
        tasks = interactor.fetchTasks()
    }
    
    
}
