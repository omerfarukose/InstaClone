//
//  FeedViewController.swift
//  InstaClone
//
//  Created by Ömer Faruk KÖSE on 17.10.2021.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromFirestore()
        
    }

    func getDataFromFirestore(){
        userEmailArray.removeAll(keepingCapacity: true)
        userCommentArray.removeAll(keepingCapacity: true)
        likeArray.removeAll(keepingCapacity: true)
        userImageArray.removeAll(keepingCapacity: true)
        let firestoreDatabase = Firestore.firestore()

        firestoreDatabase.collection("Posts").addSnapshotListener { (snapshot ,error) in
            if error != nil {
                print(error?.localizedDescription ?? "Error")
            }else{
                if snapshot?.isEmpty != true && snapshot != nil {
                    for document in snapshot!.documents {
                        let documentID = document.documentID
                        
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        if let likes = document.get("likes") as? Int{
                            self.likeArray.append(likes)
                        }
                        if let imageURL = document.get("imageURL") as? String{
                            self.userImageArray.append(imageURL)
                        }
                        if let date = document.get("date") as? String{
                     
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.usernameLabel.text = userEmailArray[indexPath.row]
        cell.commentLabel.text = userCommentArray[indexPath.row]
        cell.likeLabel.text = String(likeArray[indexPath.row])
        cell.userImagaView.image = UIImage(named: "images")
        return cell
    }
    

}
