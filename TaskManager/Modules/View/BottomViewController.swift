//
//  BottomViewController.swift
//  TaskManager
//
//  Created by Rajkumar on 04/12/24.
//

import UIKit

protocol BottomVCDelegate : AnyObject{
    func selectedPriority(Value: TaskPriority)
}

class BottomViewController: UIViewController {
    
    @IBOutlet weak var priorityTableView: UITableView!
    
    weak var delegate : BottomVCDelegate?
    
    let taskPriorities: [TaskPriority] = TaskPriority.allCases.filter { $0 != .all }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        // Do any additional setup after loading the view.
    }
    
    private func setupTableView(){
        priorityTableView.delegate = self
        priorityTableView.dataSource = self
    }
}
extension BottomViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskPriorities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "priorityTableViewCell", for: indexPath) as! priorityTableViewCell
        cell.bindData = taskPriorities[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = taskPriorities[indexPath.row]
        delegate?.selectedPriority(Value: data)
        self.dismiss(animated: true)
    }
}
