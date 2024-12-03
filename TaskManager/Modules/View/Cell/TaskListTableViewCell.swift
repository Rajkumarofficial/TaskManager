//
//  TaskListTableViewCell.swift
//  TaskManager
//
//  Created by Rajkumar on 03/12/24.
//

import UIKit

protocol TaskListCellDelegate: AnyObject{
    func didTapDelete(for index: IndexPath)
}

class TaskListTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel:UILabel?
    @IBOutlet weak var descriptionLabel:UILabel?
    
    weak var delegate: TaskListCellDelegate?
    var indexPath: IndexPath? // Store the indexPath
    
    var bindData:TaskList? {
        didSet{
            configureCell()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    private func configureCell(){
        titleLabel?.text = bindData?.taskName
        descriptionLabel?.text = bindData?.taskDescription
    }
    @IBAction func trashBttn(_ sender: UIButton){
        if let indexPath = indexPath {
            delegate?.didTapDelete(for: indexPath)
        }
    }
}
