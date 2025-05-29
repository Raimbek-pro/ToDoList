//
//  TaskListView.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//
import SwiftUI
struct TaskListView<T:TaskListPresenterProtocol>:View {
    @ObservedObject var presenter: T
    var body : some View{
        List(presenter.tasks){ task in Text(task.title)
            
        }.onAppear{
            presenter.onAppear()
        }
        
    }
}
