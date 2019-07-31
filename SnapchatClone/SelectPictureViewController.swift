//
//  SelectPictureViewController.swift
//  SnapchatClone
//
//  Created by David Daniel Leah (BFS EUROPE) on 27/06/2019.
//  Copyright © 2019 David Daniel Leah (BFS EUROPE). All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var message: UITextField!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        // Do any additional setup after loading the view.
    }
    @IBAction func cameraButtonTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType  = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    @IBAction func selectButtonTapped(_ sender: Any) {
        if imagePicker != nil {
            imagePicker!.sourceType  = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
        
    }
    @IBAction func nextButton(_ sender: Any) {
        if let message = message.text {
            if imageAdded && message != "" {
                //upload the image
                let imagesFolder = Storage.storage().reference().child("images").child(imageName)
                if let image = imageView.image,
                    let imageData = image.jpegData(compressionQuality: 0.1){
                    imagesFolder.putData(imageData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        }else {
                            // Fetch the download URL
                            imagesFolder.downloadURL { url, error in
                                if let error = error {
                                    self.presentAlert(alert: error.localizedDescription)
                                    }else {
                                    // Get the download URL for 'images/stars.jpg'
                                    let urlStr:String = (url?.absoluteString) ?? ""
                                    self.performSegue(withIdentifier: "selectReceiverSegue", sender: urlStr)
                                }
                            }
                        }
                    }
                }else{
                    print("no image")
                }
                
            }else{
                presentAlert(alert: "You must provide an image and a message")
            }
        }
    }
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecepientTableViewController{
                selectVC.downloadURL = downloadURL
                selectVC.descriprionMessage = message.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    
    //Functions
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            imageAdded = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}
