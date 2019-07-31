//
//  ViewSnapViewController.swift
//  SnapchatClone
//
//  Created by David Daniel Leah (BFS EUROPE) on 01/07/2019.
//  Copyright © 2019 David Daniel Leah (BFS EUROPE). All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage
import FirebaseAuth
import FirebaseStorage

class ViewSnapViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var snap : DataSnapshot?
    var imageName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        if let snapDict = snap?.value as? NSDictionary {
            if let fromEmail = snapDict["description"] as? String,
                let imageUrl = snapDict["imageURL"] as? String,
                let imageName = snapDict["imageName"] as? String{
                    messageLabel.text = fromEmail
                    self.imageName = imageName
                    if let url = URL(string: imageUrl){
                        imageView.sd_setImage(with: url, completed: nil)
                    }
                }
            }
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        if let currentUserId = Auth.auth().currentUser?.uid{
            if let snap = snap{
                Database.database().reference().child("users").child(currentUserId).child("snaps").child(snap.key).removeValue()
                Storage.storage().reference().child("images").child(imageName).delete(completion: nil)
            }
        }
    }

}
