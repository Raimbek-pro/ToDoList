//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 29.05.2025.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            NavigationView {
                TaskListRouter.build()
            }
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
