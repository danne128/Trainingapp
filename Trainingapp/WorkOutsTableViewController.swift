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
                noDataLabel.text          = "No data available"
                noDataLabel.textColor     = UIColor.black
                noDataLabel.textAlignment = .center
                self.tableView.backgroundView  = noDataLabel
                self.tableView.separatorStyle  = .none
                self.tableView.tableFooterView = UIView()
            }
        }
        
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
        cell.amountOfExercisesLabel.text = "This workout has \(amountOfExercises[indexPath.row]) exercises"
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
