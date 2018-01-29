//
//  CreateWorkoutAndExerciseViewController.swift
//  Trainingapp
//
//  Created by Daniel Trondsen Wallin on 2018-01-25.
//  Copyright © 2018 Daniel Trondsen Wallin. All rights reserved.
//

import UIKit
import Firebase

class CreateWorkoutAndExerciseViewController: UIViewController {
    
    @IBOutlet weak var workOutNameTextfield: UITextField!
    @IBOutlet weak var exerciseNameTextfield: UITextField!
    @IBOutlet weak var exerciseSetsTextfield: UITextField!
    @IBOutlet weak var exerciseRepsTextfield: UITextField!
    @IBOutlet weak var exerciseWeightTextfield: UITextField!
    
    var ref: DatabaseReference!
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addWorkoutWasClicked(_ sender: Any) {
        let workOutName = workOutNameTextfield.text
        let exerciseName = exerciseNameTextfield.text
        let exerciseSets = exerciseSetsTextfield.text
        let exerciseReps = exerciseRepsTextfield.text
        let exerciseWeight = exerciseWeightTextfield.text
        
        if workOutName == "" || exerciseName == "" || exerciseSets == "" || exerciseReps == "" || exerciseWeight == "" {
            print("One of your textfields are empty")
        }
        else {
            guard let uid = userID else {
                return
            }
            
            let workOutReference = self.ref.child("users").child(uid).child("workouts").child(workOutName!).child(exerciseName!)
            let workOutValues = ["Sets" : exerciseSets!, "Reps" : exerciseReps!, "Weight" : exerciseWeight!] as NSDictionary
            
            workOutReference.updateChildValues(workOutValues as! [AnyHashable : Any], withCompletionBlock: { (error, ref) in
                
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    print("added workouts")
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
            
        }
    }
    

}
