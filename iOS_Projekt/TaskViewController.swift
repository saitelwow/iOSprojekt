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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Usuń", style: .done, target: self, action: #selector(DeleteTask))
    }
    @objc func DeleteTask(){
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        let newCount = count - 1


        for i in (currentPosition! + 1)...(count + 1){
            UserDefaults().setValue(UserDefaults().value(forKey: "task_\(i + 1)"), forKey: "task_\(i)")
            UserDefaults().setValue(UserDefaults().value(forKey: "descTask_\(i + 1)"), forKey: "descTask_\(i)")
        }
        UserDefaults().setValue(newCount, forKey: "count")
        update?()

        navigationController?.popViewController(animated: true)

    }


}
