//
//  createTaskViewModel.swift
//  TaskManager
//
//  Created by Rajkumar on 04/12/24.
//

import Foundation

class createTaskViewModel {
    
    var errorMessage: String?
    
    // Validate input
    func validateCredentials(tasktittle: String, taskdescription: String, taskpriority: String) -> Bool {
        // Task Tittle
        guard !tasktittle.isEmpty else {
            errorMessage = "Enter Tittle Name."
            return false
        }
        
        // Task Priority
        guard !taskpriority.isEmpty else {
            errorMessage = "Select Task Priority Level."
            return false
        }
        
        // Task Description
        guard !taskdescription.isEmpty else {
            errorMessage = "Enter Task Description."
            return false
        }
        
        errorMessage = nil // Clear error if validation passes
        return true
    }
    
}
