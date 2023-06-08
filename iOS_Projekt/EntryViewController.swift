//
//  EntryViewController.swift
//  iOS_Projekt
//
//  Created by macOS Ventura on 01/06/2023.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var field:UITextField!
    @IBOutlet var descField:UITextView!
    
    
    var update: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        descField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Zapisz", style: .done, target: self, action: #selector(saveTask))
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    @objc func saveTask(){
        guard let text = field.text, !text.isEmpty else {
            return
        }
        guard let descText = descField.text, !descText.isEmpty else{
            return
        }
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        let newCount = count + 1
        UserDefaults().set(newCount, forKey: "count")
        UserDefaults().set(text, forKey: "task_\(newCount)")
        UserDefaults().set(descText, forKey: "descTask_\(newCount)")
        update?()
            
        navigationController?.popViewController(animated: true)
    }

}
