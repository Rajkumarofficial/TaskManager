//
//  ViewController + Extension.swift
//  TaskManager
//
//  Created by Rajkumar on 04/12/24.
//

import Foundation
import UIKit

extension UITableView{
    func registercellNib(_ cellClass: AnyClass){
        let nib = UINib(nibName: String(describing: cellClass), bundle: nil)
        register(nib, forCellReuseIdentifier: String(describing: cellClass))
    }
    func dequeueReusablecell<T : UITableViewCell>(forindexPath indexPath: IndexPath) -> T{
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: T.self),for: indexPath) as? T else{
            fatalError("cell identifier: \(String(describing: T.self))")
        }
        return cell
    }
    func showEmptyMessage(_ show: Bool, message: String = "No tasks available. Please add new tasks.") {
        if show {
            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.textAlignment = .center
            messageLabel.textColor = .gray
            messageLabel.numberOfLines = 0
            messageLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
            messageLabel.sizeToFit()
            self.backgroundView = messageLabel
        } else {
            self.backgroundView = nil
        }
    }
    func restore(){
        self.backgroundView = nil
    }
}
extension UIViewController{
    
    func pushViewController(identifier: String){
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func popViewController(){
        self.navigationController?.popViewController(animated: true)
    }
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    func showOkCancelAlert(title: String, message: String, onOk: @escaping () -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // OK Action
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            onOk() // Execute the OK action handler
        }
        alertController.addAction(okAction)
        
        // Cancel Action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert
        self.present(alertController, animated: true, completion: nil)
    }
}
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    func addBorderColor (borderColor: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.masksToBounds = false;
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
    }
    
    func makeViewCircular(){
        self.layer.cornerRadius = self.frame.size.width/2
        self.layer.masksToBounds = true
    }
}
