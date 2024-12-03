//
//  priorityTableViewCell.swift
//  TaskManager
//
//  Created by Rajkumar on 04/12/24.
//

import UIKit

class priorityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var priorityLabel: UILabel!
    
    var bindData: TaskPriority? {
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
        priorityLabel?.text = bindData?.priorityTitle
    }
}
