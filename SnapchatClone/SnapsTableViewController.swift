//
//  SnapsTableViewController.swift
//  SnapchatClone
//
//  Created by David Daniel Leah (BFS EUROPE) on 27/06/2019.
//  Copyright © 2019 David Daniel Leah (BFS EUROPE). All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {

    var snaps : [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUserId = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(currentUserId).child("snaps").observe(.childAdded) { (snapshot) in
                self.snaps.append(snapshot)
                self.tableView.reloadData()
                Database.database().reference().child("users").child(currentUserId).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    var index = 0
                    for snap in self.snaps{
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if snaps.count == 0 {
            return 1
        }else{
            return snaps.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if snaps.count == 0 {
            cell.textLabel?.text = "You have no snaps ☹️"
        }else{
            let snap = snaps[indexPath.row]
            if let snapDict = snap.value as? NSDictionary {
                if let fromEmail = snapDict["from"] as? String{
                    cell.textLabel?.text = fromEmail
                }
            }
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            if let viewVC = segue.destination as? ViewSnapViewController{
                if let snap = sender as? DataSnapshot{
                    viewVC.snap = snap
                }
            }
        }
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
}
