//
//  TaskDetailsViewController.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//

import UIKit

protocol TaskDetailsVCDelegate : AnyObject{
    func didCtrateTask()
}

class TaskDetailsViewController: UIViewController  {

    @IBOutlet weak var tittleText: UITextField!
    @IBOutlet weak var priorityText: UITextField!
    @IBOutlet weak var descriptiontext: UITextView!
    
    @IBOutlet weak var buttonLbl: UILabel!
    @IBOutlet weak var navTitleLbl: UILabel!
    
    weak var delegate: TaskDetailsVCDelegate?
    
    var priority : TaskPriority?

    var getSingleTaskData: TaskList?
    
    var isUpdate: Bool = false
    
    var viewModel = createTaskViewModel()
    var ListviewModel = TaskListViewModel()
    
    var getTitle:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tittleText.text = getSingleTaskData?.taskName
        priorityText.text = getSingleTaskData?.taskPriority
        descriptiontext.text = getSingleTaskData?.taskDescription
        buttonLbl.text = isUpdate ? "Update" : "Create"
        navTitleLbl.text = isUpdate ? "Update Task" : "New Task"
    }
    @IBAction func priorityTapped(_ sender: UIButton){
        let bottomSheet = storyboard?.instantiateViewController(withIdentifier: "BottomViewController") as! BottomViewController
        if let sheet = bottomSheet.sheetPresentationController{
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.prefersGrabberVisible = true
            
        }
        bottomSheet.delegate = self
        self.present(bottomSheet, animated: true)
    }
    @IBAction func backTapped(_ sender: UIButton){
        popViewController()
    }
    
    @IBAction func addBttn(_ sender: UIButton){
        
        if viewModel.validateCredentials(tasktittle: tittleText.text ?? "", taskdescription: priorityText.text ?? "" , taskpriority: descriptiontext.text ?? "") {
            // Proceed with login logic (e.g., navigation)
            if !isUpdate{
                ListviewModel.addTask(title: tittleText.text ?? "", description: descriptiontext.text ?? "", priority: priority ?? .all)
            } else{
                if let priority = TaskPriority(from: getSingleTaskData?.taskPriority ?? "") {
                    print("Converted to enum: \(priority)") // Outputs: Converted to enum: high
                    ListviewModel.updateTask(at: Int(getSingleTaskData?.id ?? 0), title: tittleText.text ?? "", description: descriptiontext.text ?? "", priority: priority)
                } else {
                    print("Invalid priority string")
                }
                
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                self.delegate?.didCtrateTask()
                self.popViewController()
            }
        } else {
            // Show error message
            showAlert(message: viewModel.errorMessage ?? "")
        }
    }
}
extension TaskDetailsViewController: BottomVCDelegate{
    func selectedPriority(Value: TaskPriority) {
        priority = Value
        getSingleTaskData?.taskPriority = Value.priorityTitle
        priorityText.text = Value.priorityTitle
    }
}
