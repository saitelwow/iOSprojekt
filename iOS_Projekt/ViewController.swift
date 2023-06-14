//
//  ViewController.swift
//  iOS_Projekt
//
//  Created by macOS Ventura on 01/06/2023.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet var table_view: UITableView!
    
    let motionManager = CMMotionManager()
    let shakeThreshold: Double = 1.5
    let yourList = ["Element 1", "Element 2", "Element 3", "Element 4", "Element 5"]

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
        
        motionManager.accelerometerUpdateInterval = 0.1 // Update interval in seconds, adjust as needed
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: .main) { (data, error) in
                if let acceleration = data?.acceleration {
                    let accelerationMagnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
                    
                    print("Shake się udał! \(accelerationMagnitude)")
                    
                    if accelerationMagnitude > self.shakeThreshold {
                        let randomIndex = Int.random(in: 0..<self.tytulyPrzepisow.count)
                        
                        print("Random recipe: \(self.tytulyPrzepisow[randomIndex])")
                        
                        // Navigate to the TaskViewController for the randomly selected recipe
                        let vc = self.storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
                        vc.title = "Przepis"
                        vc.task = self.tytulyPrzepisow[randomIndex]
                        vc.desc = self.przepisyOpisy[randomIndex]
                        vc.currentPosition = randomIndex
                        vc.update = {
                            DispatchQueue.main.async {
                                self.updateTasks()
                            }
                        }
                        self.navigationController?.pushViewController(vc, animated: true)

                    }
                }
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            let randomIndex = Int.random(in: 0..<tytulyPrzepisow.count)
            
            print("Random recipe: \(tytulyPrzepisow[randomIndex])")
            
            // Navigate to the TaskViewController for the randomly selected recipe
            let vc = storyboard?.instantiateViewController(identifier: "task") as! TaskViewController
            vc.title = "Przepis"
            vc.task = tytulyPrzepisow[randomIndex]
            vc.desc = przepisyOpisy[randomIndex]
            vc.currentPosition = randomIndex
            vc.update = {
                DispatchQueue.main.async {
                    self.updateTasks()
                }
            }
            navigationController?.pushViewController(vc, animated: true)
        }
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
