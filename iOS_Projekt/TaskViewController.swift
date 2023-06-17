//
//  TaskViewController.swift
//  iOS_Projekt
//
//  Created by macOS Ventura on 01/06/2023.
//

import UIKit
import CoreData

class TaskViewController: UIViewController {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descView: UITableView!
    
    var recipe: Recipe!
    var currentPosition: Int?
    var recipeSteps: [String]!
    
    var update: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descView.delegate = self
        descView.dataSource = self
        
        label.text = recipe.name
        recipeSteps = recipe.desc!.components(separatedBy: "\n").filter { !$0.isEmpty }
        if let img = recipe.image {
            imageView.image = UIImage(data: img)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Usuń", style: .done, target: self, action: #selector(DeleteTask))
    }
    
    @objc func DeleteTask() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        appDelegate.dataManager.delete(recipe)
        
        update?()
        navigationController?.popViewController(animated: true)
    }
}

extension TaskViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension TaskViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSteps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let lbl = cell.contentView.viewWithTag(2) as! UILabel
        lbl.text = recipeSteps[indexPath.row]
        
        let btnChk = cell.contentView.viewWithTag(1) as! UIButton
        btnChk.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
        
        return cell
    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
