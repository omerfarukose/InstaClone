//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Ömer Faruk KÖSE on 17.10.2021.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        let uuid = UUID().uuidString
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            let imageReference = mediaFolder.child("\(uuid).jpg")
            
            imageReference.putData(data, metadata: nil) { storageMetadat, error in
                
                if error != nil {
                    self.makeAlert(title: "Error !", message: error?.localizedDescription ?? "Error !")
                }else{
                    imageReference.downloadURL { url, error in
                        
                        let imageURL = url?.absoluteString
                        
                        let firestoreDatabase = Firestore.firestore()
                        var firestoreReference : DocumentReference? = nil
                        
                        let firestorePost = ["imageURL" : imageURL! , "postedBy" : Auth.auth().currentUser?.email , "postComment" : self.textField.text , "date" : FieldValue.serverTimestamp() , "likes" : 0] as [String : Any]
                        
                        firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost , completion: { error in
                            if error != nil {
                                self.makeAlert(title: "Error !", message: error?.localizedDescription ?? "Error !")
                            }else{
                                self.imageView.image = UIImage(named: "images")
                                self.textField.text = ""
                                self.tabBarController?.selectedIndex = 0
                            }
                        })
                    }
                }
            }
        }
    }
    
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

}
