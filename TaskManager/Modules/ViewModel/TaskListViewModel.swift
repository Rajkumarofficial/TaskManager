//
//  TaskListViewModel.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//

import Foundation
import CoreData
import UIKit

enum TaskPriority:CaseIterable {
    case all
    case critical
    case high
    case medium
    case low
    
    var priorityTitle:String{
        switch self {
        case .all: "All"
        case .critical: "Critical"
        case .high: "High"
        case .medium: "Medium"
        case .low: "Low"
        }
    }
    var priorityColor:UIColor {
        switch self {
        case .all:
              return .clear
        case .critical:
            return .red
        case .high:
            return .yellow
        case .medium:
            return .blue
        case .low:
            return .green
        }
    }
    init?(from title: String) {
        if let matchingCase = TaskPriority.allCases.first(where: { $0.priorityTitle == title }) {
            self = matchingCase
        } else {
            return nil // Return nil if no match is found
        }
    }
}

class TaskListViewModel {
    private var tasks: [TaskList] = [] // This holds all tasks
    private let coreDataHelper = CoreDataHelper.shared
    let priorities: [TaskPriority] = TaskPriority.allCases
    private var groupedTasks: [String: [TaskList]] = [:]
    private var sectionTitles: [String] = []
    
    // MARK: - Add Task
    func addTask(title: String, description: String,priority:TaskPriority) {
        _ = coreDataHelper.createTask(title: title, description: description, taskId: Int32(numberOfTasks() + 1), priority: priority)
    }
    
    // MARK: - Delete Task
    func deleteTask(at indexPath: IndexPath, completion: @escaping () -> Void) {
        // Get the section title (date) for the task
        let sectionTitle = sectionTitles[indexPath.section]
        
        // Check if the task exists in the grouped tasks
        if var tasksInSection = groupedTasks[sectionTitle], tasksInSection.indices.contains(indexPath.row) {
            let taskToDelete = tasksInSection[indexPath.row]
            
            // Delete the task from CoreData
            coreDataHelper.deleteTask(task: taskToDelete)
            
            // Remove the task from the grouped data source
            tasksInSection.remove(at: indexPath.row)
            groupedTasks[sectionTitle] = tasksInSection
            
            // If the section is now empty, remove it from the sections
            if tasksInSection.isEmpty {
                groupedTasks.removeValue(forKey: sectionTitle)
                if let sectionIndex = sectionTitles.firstIndex(of: sectionTitle) {
                    sectionTitles.remove(at: sectionIndex)
                }
            }
            
            // Update the flat task list
            if let taskIndex = tasks.firstIndex(of: taskToDelete) {
                tasks.remove(at: taskIndex)
            }
            
            completion()
        } else {
            print("Error: Task not found at indexPath \(indexPath)")
        }
    }

    
    // MARK: - Update Task
    func updateTask(at index: Int, title: String, description: String, priority:TaskPriority) {
        let updateData = coreDataHelper.updateTaskByIdAndPriority(taskId: Int32(index), priority: priority, title: title, description: description)
        
        
    }
    
    // MARK: - Get Task Count
    func numberOfTasks() -> Int {
        return tasks.count
    }
    
    // MARK: - Get Task at Index
    func taskAt(index: Int) -> TaskList {
        return tasks[index]
    }

    // MARK: - Fetch All Tasks and Group by Date
    func fetchTasks(completion: @escaping () -> Void) {
        if let fetchedTasks = coreDataHelper.fetchAllTasks() {
            tasks = fetchedTasks
            groupTasksByDate()
            completion()
        } else {
            print("Error fetching tasks")
        }
    }
    
    // MARK: - Fetch Tasks by Priority
    func fetchTasks(byPriority priority: TaskPriority, completion: @escaping () -> Void) {
            if let fetchedTasks = coreDataHelper.fetchTasks(byPriority: priority) {
                tasks = fetchedTasks
                groupTasksByDate()
                completion()
            } else {
                print("Error fetching tasks")
            }
        }
    
    // MARK: - Group Tasks by Date
    private func groupTasksByDate() {
        // Reset groupings
        groupedTasks = [:]
        sectionTitles = []
        
        // Group tasks by formatted date string (e.g., "YYYY-MM-DD")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Create a DateFormatter to format dates in "d MMMM yyyy" format
        let customDateFormatter = DateFormatter()
        customDateFormatter.dateFormat = "d MMMM yyyy"
        
        for task in tasks {
            if let taskDate = task.createdAt {
                let dateString = dateFormatter.string(from: taskDate)
                
                if groupedTasks[dateString] == nil {
                    groupedTasks[dateString] = []
                    sectionTitles.append(dateString)
                }
                groupedTasks[dateString]?.append(task)
            }
        }
        
        // Sort section titles (dates)
        sectionTitles.sort { (date1, date2) -> Bool in
            let date1Date = dateFormatter.date(from: date1)!
            let date2Date = dateFormatter.date(from: date2)!
            
            if Calendar.current.isDateInToday(date1Date) {
                return true // "Today" comes first
            } else if Calendar.current.isDateInToday(date2Date) {
                return false // "Today" comes first
            }
            return date1Date < date2Date // Otherwise, sort by date
        }
    }
    
    // MARK: - Get Number of Sections (Dates)
    func numberOfSections() -> Int {
        return sectionTitles.count
    }
    
    // MARK: - Get Number of Tasks in a Section (Date)
    func numberOfTasks(inSection section: Int) -> Int {
        let sectionTitle = sectionTitles[section]
        return groupedTasks[sectionTitle]?.count ?? 0
    }
    
    // MARK: - Get Task at Index Path
    func taskAt(indexPath: IndexPath) -> TaskList {
        let sectionTitle = sectionTitles[indexPath.section]
        return groupedTasks[sectionTitle]?[indexPath.row] ?? tasks[indexPath.row]
    }
    
    // MARK: - Get Section Title (Date)
    func titleForHeaderInSection(section: Int) -> String {
        let sectionTitle = sectionTitles[section]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: sectionTitle) {
            if Calendar.current.isDateInToday(date) {
                return "Today"
            }
            else if Calendar.current.isDateInYesterday(date) {
                return "Yesterday"
            } else {
                let customDateFormatter = DateFormatter()
                customDateFormatter.dateFormat = "d MMMM yyyy"
                return customDateFormatter.string(from: date)
            }
        }
        return sectionTitle
    }
}

