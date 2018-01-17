//
//  RegisterViewController.swift
//  Trainingapp
//
//  Created by Daniel Trondsen Wallin on 2018-01-16.
//  Copyright © 2018 Daniel Trondsen Wallin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
    

    @IBAction func signUpButtonWasClicked(_ sender: Any) {
        let name = nameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if name == "" || email == "" || password == "" {
            print("one textfield is empty")
        }
        else {
            Auth.auth().createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {
                    print(error!.localizedDescription)
                }
                else {
                    guard let uid = user?.uid else {
                        return
                    }
                    
                    let userReference = self.ref.child("users").child(uid)
                    let usersInfo = ["Name" : name!, "Email" : email!] as NSDictionary
                    
                    userReference.updateChildValues(usersInfo as! [AnyHashable : Any], withCompletionBlock: { (err, ref) in
                        if err != nil {
                            print(err!.localizedDescription)
                        }
                        else {
                            print("User added succesfully")
                            //self.performSegue(withIdentifier: "RegisterToWorkouts", sender: nil)
                        }
                    })
                    
                }
            })
        }
    }
    
    


}
