//
//  ChatroomUIViewController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-04-11.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//


import UIKit
import CoreLocation
import SwiftyJSON
import Firebase
import FirebaseFirestore

class ChatroomUIViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    private var myCollectionView: UICollectionView!
    
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
    
//    let collectionView : ChatroomController!
    var collectionview: UICollectionView!
    
    var bottomCon:NSLayoutConstraint!
    
    var show = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let background = self.chatroom.chatImage
        
//        let background = colorized(with: UIColor(r: 51, g: 255, b: 152))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.alpha = 0.9;
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layout.itemSize = CGSize(width: view.frame.width, height: 700)
//
//        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//        collectionview.dataSource = self
//        collectionview.delegate = self
//        collectionview.backgroundColor = .clear
////        collectionview.showsVerticalScrollIndicator = false
//
//        collectionview.register(ChatroomMessageCell.self, forCellWithReuseIdentifier: cellId)
//        collectionview.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionview.bounces = true
//        collectionview.alwaysBounceVertical = true //Scrolling
////        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag //Keyboard drop when scroll
//        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag //Keyboard drop when scroll
//
//        collectionview.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)
        
        
//        self.view.addSubview(collectionview)
        
        
        setupNavigationBarItems()
        self.observeMessages()
        
        setupKeyboardObservers()
        
//        collectionview.translatesAutoresizingMaskIntoConstraints = false
//        collectionview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        collectionview.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        collectionview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        bottomCon = collectionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
//        bottomCon.isActive = true
        
        
        
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
                            self.collectionview?.reloadData()
                            //SCROLL TO THE LAST INDEX eventually: ONLY DO THIS IF USER IS ME !
                            //if message.username = self.username {
                            let indexPath = NSIndexPath(item: self.chatMessages.count-1, section:0)
                            self.collectionview.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
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
    
    
    
    
    
    
//    lazy var inputContainerView: UIView = {
//
//        let containerView = UIView()
//        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//
//        containerView.backgroundColor = .white
//        //        let textField = UITextField()
//        //        textField.placeholder = "ENTER SOME TEXT"
//        //        containerView.addSubview(textField)
//        //        textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        //
//        let sendButton = UIButton(type: .system)
//        sendButton.backgroundColor = UIColor.white
//        sendButton.tintColor = .blue
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        containerView.addSubview(sendButton)
//        //Add constraints x,y,w,h
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        //References the class in ChatroomController
//        containerView.addSubview(self.inputTextField)
//        //Add constraints x,y,w,h
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//
//        let separatorLineView = UIView()
//        separatorLineView .backgroundColor = UIColor(r: 220, g: 220, b: 220)
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        containerView.addSubview(separatorLineView)
//        //Add constraints x,y,w,h
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//
//        return containerView
//    }()
//
//    override var inputAccessoryView: UIView? {
//        get{
//            return inputContainerView
//        }
//    }
//    override var canBecomeFirstResponder: Bool {
//        return true
//    }
    lazy var inputContainerView: UIView = {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: 700)
        
        collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = .clear
        //        collectionview.showsVerticalScrollIndicator = false
        
        collectionview.register(ChatroomMessageCell.self, forCellWithReuseIdentifier: cellId)
        collectionview.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionview.bounces = true
        collectionview.alwaysBounceVertical = true //Scrolling
        //        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag //Keyboard drop when scroll
        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive //Keyboard drop when scroll
        
        collectionview.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 700)
        
        containerView.backgroundColor = .white
        
        let sendButton = UIButton(type: .system)
        sendButton.backgroundColor = UIColor.white
        sendButton.tintColor = .blue
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        containerView.addSubview(sendButton)
        //Add constraints x,y,w,h
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(self.inputTextField)
        //Add constraints x,y,w,h
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: sendButton.heightAnchor).isActive = true
        
        containerView.addSubview(collectionview)
        
        
        
        
        
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        collectionview.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
        collectionview.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
        
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
        
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillHide),name: UIResponder.keyboardDidHideNotification,object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handleKeyboardDidShow(){
        print("\nDid show: \(chatMessages.count-1)")
        if chatMessages.count > 0{
            
            let indexPath = NSIndexPath(item: chatMessages.count-1, section: 0)
            self.collectionview.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
            
        }
    }
    
    
    
    
    
//    @objc func handleKeyboardWillShow(notification: NSNotification){
//        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//
////        bottomCon.constant = -250
////        view.layoutIfNeeded()
////        show = true
//        print("\n will show: ", -keyboardFrame!.height)
//        UIView.animate(withDuration: keyboardDuration!){
////            self.bottomCon.constant = -250
////            self.view.layoutIfNeeded()
//        }
//    }
    
//    @objc func handleKeyboardWillHide(notification: NSNotification){
//        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
//
////        bottomCon.constant = -50
////        view.layoutIfNeeded()
////        show = false
//        print("\n will hide: -100")
////        self.bottomCon.constant = -50
//        UIView.animate(withDuration: keyboardDuration!){
////            self.bottomCon.constant = -50
////            self.view.layoutIfNeeded()
//        }
//
//        //move the input area up somehow ..
//    }
    
    
}





























