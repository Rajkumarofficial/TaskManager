//
//  ViewController.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    //MARK: - Properties
    var viewModel = TaskListViewModel()
    
    var selectedTab: TaskPriority = .all {
        didSet {
            collectionView.reloadData() // Refresh collection view when selection changes
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        viewModel.fetchTasks {
            self.tableView.reloadData()
        }
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    //MARK: - Navigate To Add Task Page
    @IBAction func addTaskTapped(_ sender: UIBarButtonItem) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController{
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - TableView Delegate & DataSource
extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections = viewModel.numberOfSections()
        tableView.showEmptyMessage(sections == 0)
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfTasks(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListTableViewCell", for: indexPath) as! TaskListTableViewCell
        let task = viewModel.taskAt(index: indexPath.row)
        cell.indexPath = indexPath
        cell.bindData = task
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // Dequeue a reusable custom header view
        let headerView = tableView.dequeueReusableCell(withIdentifier: "DateHeaderViewCell") as! DateHeaderViewCell
        let sectionTitle = viewModel.titleForHeaderInSection(section: section)
        headerView.titleLabel.text = sectionTitle
        return headerView.contentView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.taskAt(index: indexPath.row)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailsViewController") as? TaskDetailsViewController {
            vc.isUpdate = true
            vc.delegate = self
            vc.getSingleTaskData = task
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.priorities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PriorityCollectionViewCell", for: indexPath) as! PriorityCollectionViewCell
        let priority = viewModel.priorities[indexPath.item]
        let borderColor: UIColor = (priority == selectedTab) ? UIColor(named: "subColor")! : .systemGray3
        
        cell.titlebackgroundView.addBorderColor(borderColor: borderColor, borderWidth: 0.7, cornerRadius: 20)
        
        cell.titleLabel.text = priority.priorityTitle
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 4
        return CGSize(width: width, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let priority = viewModel.priorities[indexPath.item]
        selectedTab = priority
        viewModel.fetchTasks(byPriority: priority) {
            UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                self.tableView.reloadData()
            }, completion: { _ in
                print("Fetched tasks with \(priority) priority and animation complete")
            })
            print("Fetched tasks with \(priority) priority")
        }
    }
}
extension ViewController : TaskDetailsVCDelegate{
    func didCtrateTask() {
        viewModel.fetchTasks {
            self.tableView.reloadData()
        }
    }
}
extension ViewController : TaskListCellDelegate {
    func didTapDelete(for index: IndexPath) {
        showOkCancelAlert(title: "Delete Task", message: "Are you sure you want to delete this task?") {
            self.viewModel.deleteTask(at: index){
                self.tableView.reloadData()
            }
        }
    }
}
