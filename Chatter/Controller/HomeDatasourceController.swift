//
//  HomeDatasourceController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-13.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents
import UIKit
import CoreLocation
import SwiftyJSON
import Firebase
import FirebaseFirestore

class HomeDatasourceController: DatasourceController{
    
    var importantDatasource = HomeDatasource(chatroom: [])
    var chatroom_full = [Chatroom]()
    //currentDocumentID Could cause some problems in future.. be careful of it
    var listOfDocumentID = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor(r: 232, g: 236, b: 241)
        setupNavigationBarItems()
        
        fetchHomeFeed()
    }


    
    func fetchHomeFeed() {
        var listOfDocumentID = [String]()
        let db = Firestore.firestore()
        
        //Ascend by order of distance (closest will be first), also, maybe have a Scroll up to reload button ?
        //Only if self adds it , will it go right away tho ? Maybe- check if snapshot ADD was made my USERNAME !
        //So whoever created a chatroom, will have its username as DB, also- mod permissions (gotta change DB now)
        db.collection("chatrooms").addSnapshotListener { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//
//                    print("\(document.documentID) => \(document.data())")
//
//                    let title_data = document.data()["title"]! as! String
//                    let desc_data = document.data()["desc"]! as! String
//                    let emoji_data = document.data()["emoji"]! as! String
//
//                    //For now, chatImage is hardcoded, until I figure out how to add an image to the database corresponding to the chatroom
//                    let chatroom = Chatroom(title: title_data , desc: desc_data , emoji: emoji_data, chatImage: UIImage(named: "class_image")!)
//
//                    chatrooms_real.append(chatroom)
//                    listOfDocumentID.append(document.documentID)
//                    //                        print(chatroom)
//                }
//                print("@@@@@@@@@@@@@@@")
//                print(chatrooms_real.count)
//                let homeDatasource = HomeDatasource(chatroom: chatrooms_real)
//                self.importantDatasource = homeDatasource
//                self.listOfDocumentID = listOfDocumentID
//                self.datasource = homeDatasource
//            }
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: )")
                return
            }
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added){
                    print ("\nNew chatroom Added9999999999\n")
                    let title_data = diff.document.data()["title"] as? String
                    let desc_data = diff.document.data()["desc"] as? String
                    let emoji_data = diff.document.data()["emoji"] as? String
                    let chatroom = Chatroom(title: title_data! , desc: desc_data! , emoji: emoji_data!, chatImage: UIImage(named: "class_image")!)
                    self.chatroom_full.append(chatroom)
                    listOfDocumentID.append(diff.document.documentID)
                    
                    let homeDatasource = HomeDatasource(chatroom: self.chatroom_full)
                    self.importantDatasource = homeDatasource
                    self.listOfDocumentID = listOfDocumentID
                    self.datasource = homeDatasource
                    
                    DispatchQueue.main.async{
                        self.collectionView?.reloadData()
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 110)
    }
    
    
    
    
    /////////////Spacing setup for cells 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    /////////////
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    @IBOutlet var home: UIView!
    
    @objc func createChatroom(_sender: UIButton) {
        //Storyboard?
        let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
        //CreateChat is the ID of the view in the storyboard
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateChat") as UIViewController
        present(vc, animated: true, completion: nil)
        print("Create Chatroom page")
    }
    var ok = ["one", "two", "three", "four" , "five"]
    
    //Go to cell of chat room that is clicked
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Chatroom") as? ChatroomController
//        vc?.chatroom_temp = importantDatasource.chatrooms
        vc?.chatroom = self.importantDatasource.chatrooms[indexPath.row]
        print("$$$$$$$")
        vc?.documentID = self.listOfDocumentID[indexPath.row]
        vc?.cellNumber = indexPath.row
        let cell = collectionView.cellForItem(at: indexPath)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
}

