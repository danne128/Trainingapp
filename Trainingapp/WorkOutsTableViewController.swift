//
//  WorkOutsTableViewController.swift
//  Trainingapp
//
//  Created by Daniel Trondsen Wallin on 2018-01-17.
//  Copyright © 2018 Daniel Trondsen Wallin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class WorkOutsTableViewController: UITableViewController {
    
    let array1: [String] = ["Ben", "Bröst", "Armar"]
    let array2: [Int] = [6, 4, 3]
    
    var workOuts: [String] = []
    var amountOfExercises: [Int] = []
    
    var ref: DatabaseReference!
    var userID: String!
    var workOutPath: DatabaseReference!
    
    var end = false

    override func viewDidLoad() {
        super.viewDidLoad()
        end = false
        
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        workOutPath = ref.child("users").child(userID).child("workouts")
        
        self.navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOutButtonWasClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDataButtonWasClicked))
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        end = false
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        self.tableView.backgroundView?.isHidden = true
        self.tableView.separatorStyle = .singleLine
    }
    
    func loadData() {
        
        workOutPath.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if value != nil {
                let keys = value!.allKeys
                for key in keys {
                    self.workOuts.append(key as! String)
                }
                
                for exercise in self.workOuts {
                    self.workOutPath.child(exercise).observeSingleEvent(of: .value, with: { (snapshot2) in
                        let value2 = snapshot2.value as? NSDictionary
                        let keys2 = value2!.allKeys
                        self.amountOfExercises.append(keys2.count)
                        
                        if self.amountOfExercises.count == self.workOuts.count {
                            self.end = true
                        }
                        
                        if self.end == true {
                            self.tableView.reloadData()
                        }
                    })
                }
                
            }
            else {
                print("Your workout table is empty")
                let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
                noDataLabel.font = UIFont(name: noDataLabel.font.fontName, size: 20)
                noDataLabel.text = "You dont have any workouts yet"
                noDataLabel.textColor = UIColor.black
                noDataLabel.textAlignment = .center
                
                
                let addDataButton: UIButton = UIButton(frame: CGRect(x: 100, y: 100, width: 200, height: 50))
                addDataButton.backgroundColor = .black
                addDataButton.setTitle("Add a workout", for: .normal)
                addDataButton.titleLabel?.font = UIFont(name: (addDataButton.titleLabel?.font.fontName)!, size: 20)
                addDataButton.titleLabel?.adjustsFontSizeToFitWidth = true
                addDataButton.frame.origin = CGPoint(x: self.tableView.bounds.size.width*0.25, y: self.tableView.bounds.height*0.5)
                addDataButton.addTarget(self, action: #selector(self.addDataButtonWasClicked), for: .touchUpInside)
                
                
                self.tableView.backgroundView  = noDataLabel
                self.tableView.addSubview(addDataButton)
                self.tableView.separatorStyle  = .none
                self.tableView.tableFooterView = UIView()
            }
        }
    }
    
    @objc func addDataButtonWasClicked() {
        performSegue(withIdentifier: "workOutsToCreateWorkout", sender: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return workOuts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.tableFooterView = UIView()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WorkOutsTableViewCell
        
        cell.workOutNameLabel.adjustsFontSizeToFitWidth = true
        cell.amountOfExercisesLabel.adjustsFontSizeToFitWidth = true
        cell.workOutNameLabel.text = workOuts[indexPath.row]
        if amountOfExercises[indexPath.row] == 1 {
            cell.amountOfExercisesLabel.text = "This workout has \(amountOfExercises[indexPath.row]) exercise"
        }
        else {
            cell.amountOfExercisesLabel.text = "This workout has \(amountOfExercises[indexPath.row]) exercises"
        }
        
        return cell
    }
    
    @objc func logOutButtonWasClicked() {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

}
