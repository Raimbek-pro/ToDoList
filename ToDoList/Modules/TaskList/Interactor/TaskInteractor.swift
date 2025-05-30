//
//  TaskInteractor.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import Foundation

protocol TaskListInteractorProtocol {
    func fetchTasks(completion:@escaping ([TaskEntity])-> Void)
}

class TaskListInteractor: TaskListInteractorProtocol {
    func fetchTasks(completion : @escaping([TaskEntity])-> Void) {
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
                        isCompleted: $0.completed
                    )
                }
                
                DispatchQueue.main.async {
                    completion(tasks)
                }
            }.resume()
        })
    
       

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
