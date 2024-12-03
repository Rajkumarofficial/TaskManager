//
//  TaskList+CoreDataProperties.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//
//

import Foundation
import CoreData


extension TaskList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskList> {
        return NSFetchRequest<TaskList>(entityName: "TaskList")
    }

    @NSManaged public var taskName: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var id: Int32
    @NSManaged public var createdAt: Date?
    @NSManaged public var taskPriority: String?

}

extension TaskList : Identifiable {

}
