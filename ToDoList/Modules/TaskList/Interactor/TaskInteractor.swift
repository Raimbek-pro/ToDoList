//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import Foundation
import CoreData

protocol TaskListInteractorProtocol {
    func fetchCoreDataTasks(completion:@escaping ([TaskEntity])-> Void)
    func fetchNetworkTasks(completion:@escaping ([TaskEntity])-> Void)
    func addTask(title: String, taskDescription: String, completion: @escaping () -> Void)
    func updateTask(id: Int64, newTitle: String, newDescription: String, newIsCompleted: Bool, completion: @escaping () -> Void)
    func deleteTask(id: Int64, completion: @escaping () -> Void)
    func saveTasksToCoreData(tasks: [TaskEntity], completion: @escaping () -> Void)
    
}


class TaskListInteractor: TaskListInteractorProtocol {
    private let persistenceController: PersistenceController

       init(persistenceController: PersistenceController = .shared) {
           self.persistenceController = persistenceController
       }

    func fetchCoreDataTasks(completion: @escaping ([TaskEntity]) -> Void) {
        let context = persistenceController.container.viewContext
       // let context = PersistenceController.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Item>(entityName: "Item")

        do {
            let items = try context.fetch(fetchRequest)
            let tasks = items.map {
                TaskEntity(
                    id: $0.id,
                    title: $0.title ?? "",
                    description: $0.taskDescription ?? "",
                    creationDate: $0.creationDate ?? Date(),
                    isCompleted: $0.isCompleted,
                    isLocal: true
                )
            }
            completion(tasks)
        } catch {
            print("Error fetching tasks: \(error)")
            completion([])
        }
    }
    func fetchNetworkTasks(completion : @escaping([TaskEntity])-> Void) {
        DispatchQueue.global().async (execute:{
            guard let url = URL(string:"https://dummyjson.com/todos") else {
                DispatchQueue.main.async{
                    completion([])
                }
                return
            }
            URLSession.shared.dataTask(with:url){data,response,error in
                guard let data = data,
                      let decoded = try? JSONDecoder().decode(TodoResponse.self , from: data) else {
                    DispatchQueue.main.async{
                        completion([])
                    }
                    return
                }
                
                
                let tasks = decoded.todos.map{
                    TaskEntity(
                        id :Int64($0.id),
                        title: $0.todo,
                        description: "User ID: \($0.userId)",
                        creationDate: Date(),
                        isCompleted: $0.completed,
                        isLocal: false
                    )
                }
                
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }.resume()
        })
    
       

    }
    
    
    func addTask(title: String, taskDescription: String, completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            let context = self.persistenceController.container.viewContext
           // let context = PersistenceController.shared.container.viewContext

            let task = Item(context: context)
            task.id = Int64(Date().timeIntervalSince1970)
            task.title = title
            task.taskDescription = taskDescription
            task.creationDate = Date()
            task.isCompleted = false

            do {
                try context.save()
            } catch {
                print("Error saving task: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    func updateTask(id: Int64, newTitle: String, newDescription: String, newIsCompleted: Bool, completion: @escaping () -> Void) {
          DispatchQueue.global().async {
              let context = self.persistenceController.container.viewContext
              //let context = PersistenceController.shared.container.viewContext
              let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
              fetchRequest.predicate = NSPredicate(format: "id == %d", id)

              do {
                  if let task = try context.fetch(fetchRequest).first {
                      task.title = newTitle
                      task.taskDescription = newDescription
                      task.isCompleted = newIsCompleted

                      try context.save()
                      DispatchQueue.main.async {
                          completion()
                      }
                  }
              } catch {
                  print("Error updating task: \(error.localizedDescription)")
                  DispatchQueue.main.async {
                      completion()
                  }
              }
          }
      }

     
      func deleteTask(id: Int64, completion: @escaping () -> Void) {
          DispatchQueue.global().async {
              let context = self.persistenceController.container.viewContext
             // let context = PersistenceController.shared.container.viewContext
              let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
              fetchRequest.predicate = NSPredicate(format: "id == %d", id)

              do {
                  if let task = try context.fetch(fetchRequest).first {
                      context.delete(task)
                      try context.save()
                      DispatchQueue.main.async {
                          completion()
                      }
                  }
              } catch {
                  print("Error deleting task: \(error.localizedDescription)")
                  DispatchQueue.main.async {
                      completion()
                  }
              }
          }
      }
    func saveTasksToCoreData(tasks: [TaskEntity], completion: @escaping () -> Void) {
        DispatchQueue.global().async {
            let context = self.persistenceController.container.viewContext
        //    let context = PersistenceController.shared.container.viewContext
            
            for task in tasks {
                let newItem = Item(context: context)
                newItem.id = task.id
                newItem.title = task.title
                newItem.taskDescription = task.description
                newItem.creationDate = task.creationDate
                newItem.isCompleted = task.isCompleted
            }

            do {
                try context.save()
            } catch {
                print("Failed to save tasks to CoreData: \(error.localizedDescription)")
            }

            DispatchQueue.main.async {
                completion()
            }
        }
    }
}
struct TodoResponse: Codable {
    let todos: [TodoItem]
}

struct TodoItem: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId : Int
}
