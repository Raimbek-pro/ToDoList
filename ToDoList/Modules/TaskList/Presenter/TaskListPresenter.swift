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
    func addTask(title: String, taskDescription: String)
    func updateTask(id: Int64, newTitle: String, newDescription: String, newIsCompleted: Bool)
    func deleteTask(id: Int64)
}

class TaskListPresenter: TaskListPresenterProtocol,ObservableObject {
    @Published var tasks: [TaskEntity] = []
    private let interactor : TaskListInteractorProtocol
    init(interactor: TaskListInteractorProtocol) {
          self.interactor = interactor
      }
    func onAppear() {
        // Create a DispatchGroup to wait for both tasks to complete
        let dispatchGroup = DispatchGroup()

        var fetchedNetworkTasks: [TaskEntity] = []
        var fetchedCoreDataTasks: [TaskEntity] = []

        // Fetch tasks from the network
        dispatchGroup.enter()
        interactor.fetchNetworkTasks { networkTasks in
            fetchedNetworkTasks = networkTasks
            dispatchGroup.leave()
        }

        // Fetch tasks from Core Data
        dispatchGroup.enter()
        interactor.fetchCoreDataTasks { coreDataTasks in
            fetchedCoreDataTasks = coreDataTasks
            dispatchGroup.leave()
        }

        // When both tasks are completed, update the presenter
        dispatchGroup.notify(queue: .main) {
            // Combine tasks from both sources
            self.tasks = fetchedNetworkTasks + fetchedCoreDataTasks
        }
    }
    func addTask(title: String, taskDescription: String) {
          interactor.addTask(title: title, taskDescription: taskDescription) { [weak self] in
              //  перезапрашиваем список
              self?.onAppear()
          }
      }
    
    func updateTask(id: Int64, newTitle: String, newDescription: String, newIsCompleted: Bool) {
        interactor.updateTask(id: id, newTitle: newTitle, newDescription: newDescription, newIsCompleted: newIsCompleted) { [weak self] in
            // Refresh the task list after updating
            self?.onAppear()
        }
    }

   
    func deleteTask(id: Int64) {
        interactor.deleteTask(id: id) { [weak self] in
            // Refresh the task list after deleting
            self?.onAppear()
        }
    }
    
    
    
}
