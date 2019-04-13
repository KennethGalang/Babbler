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
        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive //Keyboard drop when scroll
        collectionview.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
//
        
        
        self.view.addSubview(collectionview)
        
        
        
        
        
        collectionview.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        collectionview.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        collectionview.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        collectionview.heightAnchor.constraint(equalTo: self.view.heightAnchor).isActive = true
        
        
        setupNavigationBarItems()
        self.observeMessages()
        
        setupKeyboardObservers()
    }
    
    func colorized(with color: UIColor) -> UIImage? {
        guard
            
            let ciimage = CIImage(image: self.chatroom.chatImage),
            let colorMatrix = CIFilter(name: "CIColorMatrix")
            else { return nil }
        
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        colorMatrix.setDefaults()
        colorMatrix.setValue(ciimage, forKey: "inputImage")
        colorMatrix.setValue(CIVector(x: r, y: 0, z: 0, w: 0), forKey: "inputRVector")
        colorMatrix.setValue(CIVector(x: 0, y: g, z: 0, w: 0), forKey: "inputGVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: b, w: 0), forKey: "inputBVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: 0, w: a), forKey: "inputAVector")
        if let ciimage = colorMatrix.outputImage {
            
            return UIImage(ciImage: ciimage).rotate(radians: .pi/2)
        }
        return nil
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
        
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillShow),name: UIResponder.keyboardWillShowNotification,object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillHide),name: UIResponder.keyboardWillHideNotification,object: nil)
//        NotificationCenter.default.addObserver(self,selector: #selector(handleKeyboardWillHide),name: UIResponder.keyboardDidHideNotification,object: nil)
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @objc func handleKeyboardDidShow(){
        if chatMessages.count > 0{
            
//            let bottomConstraint = NSLayoutConstraint(item: collectionview, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
//            self.view.addConstraint(bottomConstraint)
//            bottomConstraint?.constant = -
            
            let indexPath = NSIndexPath(item: chatMessages.count-1, section: 0)
            print("\nDid show: \(chatMessages.count-1)")
//            collectionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -300).isActive = true
            
            
            collectionview.scrollToItem(at: indexPath as IndexPath, at: .top, animated: true)
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
