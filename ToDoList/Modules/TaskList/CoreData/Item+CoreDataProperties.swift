//
//  Item+CoreDataProperties.swift
//  ToDoList
//
//  Created by Райымбек Омаров on 30.05.2025.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var creationDate: Date?
    @NSManaged public var id: Int64
    @NSManaged public var isCompleted: Bool
    @NSManaged public var taskDescription: String?
    @NSManaged public var title: String?

}

extension Item : Identifiable {

}
