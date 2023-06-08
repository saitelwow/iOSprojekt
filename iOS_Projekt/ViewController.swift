//
//  ViewController.swift
//  iOS_Projekt
//
//  Created by macOS Ventura on 01/06/2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var table_view: UITableView!
    
    var tytulyPrzepisow = [String]()
    var przepisyOpisy = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Przepisy"
        
        table_view.delegate = self
        table_view.dataSource = self
        
        
        
        if !UserDefaults().bool(forKey: "setup"){
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        updateTasks()
        // Do any additional setup after loading the view.
    }
    func updateTasks(){
        tytulyPrzepisow.removeAll()
        przepisyOpisy.removeAll()
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }
        for i in 0..<count{
            if let task = UserDefaults().value(forKey: "task_\(i+1)") as?String {
                tytulyPrzepisow.append(task)
            }
            if let descTask = UserDefaults().value(forKey: "descTask_\(i+1)") as? String{
                przepisyOpisy.append(descTask)
            }
        }
        table_view.reloadData()
    }
    
    @IBAction func didTapAdd(){
        let vc = storyboard?.instantiateViewController(identifier: "entry") as! EntryViewController
        vc.title = "Nowy przepis"
        
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table_view.deselectRow(at: indexPath, animated: true)
        
        
        let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
        vc.title = "Przepis"
        vc.task = tytulyPrzepisow[indexPath.row]
        vc.desc = przepisyOpisy[indexPath.row]
        vc.currentPosition = indexPath.row
        vc.update = {
            DispatchQueue.main.async{
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tytulyPrzepisow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table_view.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tytulyPrzepisow[indexPath.row]
        return cell
    }
}
