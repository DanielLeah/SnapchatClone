//
//  SelectRecepientTableViewController.swift
//  SnapchatClone
//
//  Created by David Daniel Leah (BFS EUROPE) on 28/06/2019.
//  Copyright © 2019 David Daniel Leah (BFS EUROPE). All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
class SelectRecepientTableViewController: UITableViewController {
    
    var downloadURL = ""
    var users : [User] = []
    var descriprionMessage = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("users").observe(.childAdded) { (snapshot) in
            let user = User()
            if let userDict = snapshot.value as? NSDictionary{
                if let email = userDict["email"] as? String {
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.email
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let senderEmail = Auth.auth().currentUser?.email {
            let snap = ["from":senderEmail, "description":descriprionMessage, "imageURL" : downloadURL, "imageName" : imageName ]
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

class User {
    var email = ""
    var uid = ""
}
