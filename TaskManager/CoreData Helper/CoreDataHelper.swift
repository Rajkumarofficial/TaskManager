//
//  CoreDataHelper.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//

import Foundation
import CoreData
import UIKit

class CoreDataHelper {
    static let shared = CoreDataHelper()
    
    private init() {}
    
    // Get the context from the AppDelegate
    private var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    // MARK: - Create Task
    func createTask(title: String, description: String,taskId:Int32, priority:TaskPriority) -> TaskList? {
        let task = TaskList(context: context)
        task.id = taskId
        task.taskName = title
        task.taskDescription = description
        task.taskPriority = priority.priorityTitle
        task.createdAt = Date()
        
        saveContext()
        return task
    }
    
    // MARK: - Fetch Task by ID
    func fetchTaskByIdAndPriority(taskId: Int32, priority: TaskPriority) -> TaskList? {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        
        // Combine conditions using AND
        let idPredicate = NSPredicate(format: "id == %d", taskId)
        let priorityPredicate = NSPredicate(format: "taskPriority == %@", priority.priorityTitle)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, priorityPredicate])
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching task by ID and Priority: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Update Task by ID
    func updateTaskByIdAndPriority(taskId: Int32, priority: TaskPriority, title: String?, description: String?) -> Bool {
        guard let task = fetchTaskByIdAndPriority(taskId: taskId, priority: priority) else {
            print("Task not found with ID \(taskId) and Priority \(priority.priorityTitle)")
            return false
        }
        
        // Update fields if non-nil
        if let newTitle = title {
            task.taskName = newTitle
        }
        if let newDescription = description {
            task.taskDescription = newDescription
        }
        
        // Save changes
        saveContext()
        return true
    }

    
    func fetchTasks(byPriority priority: TaskPriority) -> [TaskList]? {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        
        if priority != .all {
            fetchRequest.predicate = NSPredicate(format: "taskPriority == %@", priority.priorityTitle)
        }
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Error fetching tasks by priority: \(error.localizedDescription)")
            return nil
        }
    }
    // MARK: - Fetch All Tasks
    func fetchAllTasks() -> [TaskList]? {
        let fetchRequest: NSFetchRequest<TaskList> = TaskList.fetchRequest()
        
        do {
            let tasks = try context.fetch(fetchRequest)
            return tasks
        } catch {
            print("Error fetching tasks: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Delete Task
    func deleteTask(task: TaskList) {
        context.delete(task)
        saveContext()
    }
    
    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }
}
