//
//  TaskViewController.swift
//  iOS_Projekt
//
//  Created by macOS Ventura on 01/06/2023.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet var label:UILabel!
    @IBOutlet var descField:UITextView!
    
    var task:String?
    var desc:String?
    var currentPosition:Int?
    
    var update: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        label.text = task
        descField.text = desc
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Usuń", style: .done, target: self, action: #selector(DeleteTask))
    }
//    @objc func DeleteTask(){
//        guard let count = UserDefaults().value(forKey: "count") as? Int else{
//            return
//        }
//        let newCount = count - 1
//        UserDefaults().setValue(newCount, forKey: "count")
//
//        //currentPosition = indexPath.row
//        //current positions => pozycja aktualnego przepisu
//        UserDefaults().setValue(nil, forKey: "task_\(currentPosition)")
//
//        update?()
//
//        navigationController?.popViewController(animated: true)
//
//    }


}
