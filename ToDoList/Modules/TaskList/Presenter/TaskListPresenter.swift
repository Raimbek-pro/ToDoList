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
        let hasLoadedInitialData = UserDefaults.standard.bool(forKey: "hasLoadedInitialData")

        if hasLoadedInitialData {
            interactor.fetchCoreDataTasks { [weak self] coreDataTasks in
                DispatchQueue.main.async {
                    self?.tasks = coreDataTasks
                }
            }
        } else {
            interactor.fetchNetworkTasks { [weak self] networkTasks in
                // сохраняем в CoreData
                self?.interactor.saveTasksToCoreData(tasks: networkTasks) {
                    // отмечаем, что данные были загружены
                    UserDefaults.standard.set(true, forKey: "hasLoadedInitialData")
                    self?.interactor.fetchCoreDataTasks { coreDataTasks in
                        DispatchQueue.main.async {
                            self?.tasks = coreDataTasks
                        }
                    }
                }
            }
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
