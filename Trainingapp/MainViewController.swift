//
//  MainViewController.swift
//  Trainingapp
//
//  Created by Daniel Trondsen Wallin on 2018-01-16.
//  Copyright © 2018 Daniel Trondsen Wallin. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var ref: DatabaseReference!
    var userID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.7)
        
        signInButton.backgroundColor = UIColor(red: 223/255, green: 129/255, blue: 188/255, alpha: 1.0)
        signUpButton.backgroundColor = UIColor(red: 223/255, green: 129/255, blue: 188/255, alpha: 1.0)
        
        
        ref = Database.database().reference()
        userID = Auth.auth().currentUser?.uid
        
        // check if user is logged in
        if Auth.auth().currentUser != nil {
            //if user is signed in it will be transfered to the next window
            //performSegue(withIdentifier: "mainToWorkouts", sender: nil)
        }
        else {
            print("user is not signed on")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButtonWasClicked(_ sender: Any) {
        let email = emailTextField.text
        let password = passwordTextField.text
        
        if email == "" || password == "" {
            print("One of the textfields are empty")
        }
        else {
            Auth.auth().signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error == nil {
                    print("user logged in")
                    //self.performSegue(withIdentifier: "mainToWorkouts", sender: nil)
                }
                else {
                    print(error!.localizedDescription)
                }
            })
        }
    }
    

}
