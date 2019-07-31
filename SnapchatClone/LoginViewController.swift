//
//  ViewController.swift
//  SnapchatClone
//
//  Created by David Daniel Leah (BFS EUROPE) on 27/06/2019.
//  Copyright © 2019 David Daniel Leah (BFS EUROPE). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var logInOutlet: UIButton!
    @IBOutlet weak var signUpOutlet: UIButton!
    
    var signUpMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func logInTapped(_ sender: Any) {
        if let email = emailText.text,
            let password = passwordText.text{
            if signUpMode{
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    }else{
                        if let user = user {
                            Database.database().reference().child("users").child(user.user.uid).child("email").setValue(user.user.email)
                            self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                        }
                        
                    }
                }
            }else{
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if let error = error {
                        self.presentAlert(alert: error.localizedDescription)
                    }else{
                        self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                    }
                }
            }
        }
    }
    
    //Functions
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        if signUpMode {
            //Switch to log in
            signUpMode = false
            logInOutlet.setTitle("Log in", for: .normal)
            signUpOutlet.setTitle("Switch to Sign Up", for: .normal)
        }else{
            //Switch to Sign Up
            signUpMode = true
            logInOutlet.setTitle("Sign up", for: .normal)
            signUpOutlet.setTitle("Switch to Log In", for: .normal)
        }
    }
    
}

