//
//  File.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-04.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import Foundation

import LBTAComponents
import UIKit
import CoreLocation
import SwiftyJSON
import Firebase
import FirebaseFirestore

class ChatroomController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    //extension
    var containerViewBottomAnchor: NSLayoutConstraint?
    //
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Chit chat chit chat" //Until I think of something better.. this is kinda lame lol
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 13)
        return textField
    }()
    
    var chatMessages = [ChatMessage]()
    
    let headerId = "headerId"
    let cellId = "cellId"
    
//    var chatroom = Chatroom(title: "", desc: "", emoji: "", documentID: "", latitude: 5.0, longitude: 5.0, distanceToUser: 5.0, distanceRadius: 0, chatImage: UIImage(named: "perth_image")!)
//    var chatroom = Chatroom(title: "", desc: "", emoji: "", documentID: "", latitude: 5.0, longitude: 5.0, distanceToUser: 5.0, chatImage: UIImage(named: "perth_image")!)
    var chatroom = Chatroom(title: "", desc: "", emoji: "", documentID: "", URL: "", latitude: 5.0, longitude: 5.0, distanceToUser: 5.0, distanceRadius: 5.0, chatImage: UIImage(named: "perth_image")!)
    var documentID = "a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bgImage = UIImageView();
        bgImage.image = self.chatroom.chatImage
//        bgImage.translatesAutoresizingMaskIntoConstraints = true
//        bgImage.contentMode = .scaleAspectFill
        bgImage.widthAnchor.constraint(equalToConstant: self.view.bounds.width + 20).isActive = true
        bgImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height - 50).isActive = true
        let viewBackground = UIView()
        viewBackground.addSubview(bgImage)
        self.collectionView.backgroundView = bgImage
//        self.view.addSubview(viewBackground)
//        bgImage.contentMode = .scaleAspectFill
//        self.collectionView?.backgroundColor = .clear
        
        
        collectionView?.register(ChatroomMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        self.collectionView.bounces = true
        self.collectionView.alwaysBounceVertical = true //Scrolling
        self.collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive //Keyboard drop when scroll
        
        collectionView?.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)
        
        
        //        let indexPath = NSIndexPath(row: self.chatMessages.count-1, section: 0)
        //        self.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
        
//        print("This is my description\n")
//        //        print (self.desc)
//        print("OMFG YES\n", chatroom)
//        print("wtf man")
        
        print("\n\nLAT:" , chatroom.latitude, "LONGITUDE",  chatroom.longitude)
        print("Distance: ", chatroom.distanceToUser)
        print("Distance radius: ", chatroom.distanceRadius)
        
//        print("\n\nDistnce DATA!!!#@!#@!#!@$!@#!@$!: ", chatroom.distanceToUser, "\n\n\n")
//        print("This is the row picked: ", cellNumber)
//        print("NOW MY DOC ID OF CHATROOM!", documentID)
        print(Date())
        //        title_chat = title_sent
        
        setupNavigationBarItems()
        
        self.observeMessages()
        
        //        setupInputComponents()
        setupKeyboardObservers()
        
    
        
    }
    
    
    func observeMessages(){
        let db = Firestore.firestore()
        
        db.collection("chatrooms").document(self.documentID).collection("messages").order(by: "timestamp")
            .addSnapshotListener { querySnapshot, error in
                guard let snapshot = querySnapshot else {
                    print("Error fetching snapshots: \(error!)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
//                        print("Data:  \(diff.document.data())")
                        print("omg !", diff.document.data()["text"]!, "and this", diff.document.documentID)
                        
                        //Init message object
                        let message = ChatMessage(username: diff.document.data()["username"] as! String, text: diff.document.data()["text"] as! String, timestamp: diff.document.data()["timestamp"] as? NSNumber, reactions: diff.document.data()["reactions"] as! [String])
//                        print("message.text: ", message.text)
                        self.chatMessages.append(message)
                        
                        //Reloading data here @@@@@@@@@@
                        DispatchQueue.main.async{
                            self.collectionView?.reloadData()
                            //SCROLL TO THE LAST INDEX eventually: ONLY DO THIS IF USER IS ME !
                            //if message.username = self.username {
                            let indexPath = NSIndexPath(item: self.chatMessages.count-1, section:0)
                            self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                            //}
                        }
                    }
                    if (diff.type == .modified) {
                        print("Modified city: \(diff.document.data())")
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
                
        }
    }
    
    func printWhenDone(){
        print("I am done lol")
    }
    
    
    
   
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = .white
//        let textField = UITextField()
//        textField.placeholder = "ENTER SOME TEXT"
//        containerView.addSubview(textField)
//        textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//
        let sendButton = UIButton(type: .system)
        sendButton.backgroundColor = UIColor.white
        sendButton.tintColor = .blue
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //Add constraints x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        //References the class in ChatroomController
        containerView.addSubview(self.inputTextField)
        //Add constraints x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView .backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //Add constraints x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get{
            return inputContainerView
        }
    }
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
  }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleKeyboardDidShow(){
        if chatMessages.count > 0{
            let indexPath = NSIndexPath(item: chatMessages.count-1, section: 0)
            collectionView?.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
        }
    }
    
//    @objc func handleKeyboardWillShow(notification: NSNotification){
//        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        containerViewBottomAnchor?.constant = -keyboardFrame!.height
//
////        UIView.animate(withDuration: keyboardDuration!){
////            self.view.layoutIfNeeded()
////        }
//
//        //Isn't working.. watch firebase video lol
//        UIView.animate(withDuration: keyboardDuration!, delay: 0.0, options: [], animations: {
//            self.view.layoutIfNeeded()
//        }, completion: { (finished: Bool) in
//
//            DispatchQueue.main.async{
//                let indexPath = NSIndexPath(item: self.chatMessages.count-1, section:0)
//                self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
//            }
//            print("\n\nCompleted clicking on keyboard\n\n")
//        })
//
//    }
//    @objc func handleKeyboardWillHide(notification: NSNotification){
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//        containerViewBottomAnchor?.constant = 0
//
//        UIView.animate(withDuration: keyboardDuration!){
//            self.view.layoutIfNeeded()
//        }
//
//        //move the input area up somehow ..
//    }
    
    
    
    
    
    
    
    

}
