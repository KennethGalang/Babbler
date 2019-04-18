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
import Foundation
import InputBarAccessoryView


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
    var newView = UIView()
    var show = false
    
    private var keyboardManager = KeyboardManager()
    
    var customView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
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
        
        
        
//                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//                layout.itemSize = CGSize(width: view.frame.width, height: 700)
//
//                collectionview = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
//                collectionview.dataSource = self
//                collectionview.delegate = self
//                collectionview.backgroundColor = .clear
//        //        collectionview.showsVerticalScrollIndicator = false
//
//                collectionview.register(ChatroomMessageCell.self, forCellWithReuseIdentifier: cellId)
//                collectionview.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//                collectionview.bounces = true
//                collectionview.alwaysBounceVertical = true //Scrolling
////                collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive //Keyboard drop when scroll
        
//                collectionview.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)
//                collectionview.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
//                collectionview.keyboardDismissMode = .interactive
//                // Only necessary for empty collectionView
//
//
//                self.view.addSubview(collectionview)
//        inputTextField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        bottomCon = collectionview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50)
//        bottomCon.isActive = true
//
//        self.view.addSubview(inputTextField)
        
        
        
//        newView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        newView.addSubview(inputTextField)
//                inputTextField.leftAnchor.constraint(equalTo: newView.leftAnchor, constant: 8).isActive = true
//                inputTextField.centerYAnchor.constraint(equalTo: newView.centerYAnchor).isActive = true
//                inputTextField.rightAnchor.constraint(equalTo: newView.rightAnchor).isActive = true
//                inputTextField.heightAnchor.constraint(equalTo: newView.heightAnchor).isActive = true
//
//        self.view.addSubview(newView)
//
//        // Binding the inputBar will set the needed callback actions to position the inputBar on top of the keyboard
//        keyboardManager.bind(inputAccessoryView: newView)
//
//        // Binding to the tableView will enabled interactive dismissal
//        keyboardManager.bind(to: collectionview)
//
//        // Add some extra handling to manage content inset
//        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
//            let barHeight = self?.newView.bounds.height ?? 0
//            self?.collectionview.contentInset.bottom = barHeight + notification.endFrame.height
//            self?.collectionview.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
//            }.on(event: .didHide) { [weak self] _ in
//                let barHeight = self?.newView.bounds.height ?? 0
//                self?.collectionview.contentInset.bottom = barHeight
//                self?.collectionview.scrollIndicatorInsets.bottom = barHeight
//        }
        
    
        

        
        
        setupNavigationBarItems()
        setupFakeNavBar()
        self.observeMessages()
        
        
       
        
//        let window = UIApplication.shared.keyWindow!
//        let v = UIView(frame: window.bounds)
//        window.addSubview(v);
////        v.backgroundColor = UIColor.black
//        let v2 = UIView(frame: CGRect(x: 50, y: 50, width: 100, height: 50))
//        v2.backgroundColor = UIColor.white
//        v.addSubview(v2)
        
//
        setupKeyboardObservers()
        
//        collectionview.translatesAutoresizingMaskIntoConstraints = false
//        collectionview.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        collectionview.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        collectionview.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        collectionview.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
//        inputText.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        
        
        
    }
    
    
    
    func setupFakeNavBar(){
        // this does the trick
        DispatchQueue.main.async {
            let statusBarHeight = UIApplication.shared.statusBarView?.frame.height
            self.customView.frame = CGRect(x: 0, y: statusBarHeight!, width: self.view.frame.width, height: 44)
            self.customView.translatesAutoresizingMaskIntoConstraints = false
            self.customView.backgroundColor = UIColor(r: 204, g: 255, b: 255)
            self.customView.isUserInteractionEnabled = true
            let backbutton = UIButton(type: .system)
            backbutton.setImage(UIImage(named: "backImage"), for: .normal)
            backbutton.frame = CGRect(x: 0, y: 0, width: self.view.frame.width/7, height: 44)
            
            //
            //
            //                    backbutton.translatesAutoresizingMaskIntoConstraints = false
            
            //                    backbutton.setTitle("Leave", for: .normal)
            //                    backbutton.backgroundColor = .white
            backbutton.setTitleColor(.black, for: .normal) // You can change the TitleColor
            backbutton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
            backbutton.isUserInteractionEnabled = true
            //                    self.view.addSubview(backbutton)
            self.customView.addSubview(backbutton)
            
            self.customView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
            
            UIApplication.shared.windows.last?.addSubview(self.customView)
        }
    }
    
    
    @IBAction func backAction(_ sender: Any) {
        
        print("\n\nExiting CHATROOM\n\n")
//        self.view?.popViewControllerAnimated(true)
        self.customView.removeFromSuperview()
        self.navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setupFakeNavBar()
////        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
////
    var ok: UIView!
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
                self.customView.removeFromSuperview()
    }
    
//    @objc func handlePan(_ sender: UIPanGestureRecognizer) {
//        if sender.state == .changed {
//            let translation = sender.translation(in: view)
//
//            if translation.y < 0 && collectionview.isAtBottom && !self.inputTextField.isFirstResponder {
//                self.inputTextField.becomeFirstResponder()
//            }
////            if translation.y < 0 && collectionview.isAtBottom && !self.inputTextField.isFirstResponder  {
////                bottomCon.constant = translation.y
////                print("translation.y = ", bottomCon.constant, "\n")
////            }
//        }
//    }
    
    
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
//        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive //Keyboard drop when scroll

        collectionview.contentInset = UIEdgeInsets(top:0, left: 0, bottom: 8, right: 0)

//                        collectionview.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
                        collectionview.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: self.view.frame.height-63)

        containerView.backgroundColor = .clear
        
        
        let fillerView = UIView()
        fillerView .backgroundColor = .white
        fillerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(fillerView)
        //Add constraints x,y,w,h
        fillerView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        fillerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        fillerView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        fillerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
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
        inputTextField.backgroundColor = .white
        sendButton.backgroundColor = .white
        containerView.addSubview(collectionview)
        containerView.sendSubviewToBack(collectionview)

        let separatorLineView = UIView()
        separatorLineView .backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        //Add constraints x,y,w,h
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.bottomAnchor.constraint(equalTo: inputTextField.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        



        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        collectionview.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        collectionview.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        collectionview.bottomAnchor.constraint(equalTo: separatorLineView.topAnchor).isActive = true
        
        return containerView
        
    }()
    
    override var inputAccessoryView: UIView? {
        get{
            let newView = inputContainerView


            return newView
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
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        NotificationCenter.default.removeObserver(self)
//    }
//
//
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

extension UIApplication {
    /// Returns the status bar UIView
    var statusBarView: UIView? {
        
        return value(forKey: "statusBar") as? UIView
    }
    
}



class NSLayoutConstraintSet {
    
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var left: NSLayoutConstraint?
    var right: NSLayoutConstraint?
    var centerX: NSLayoutConstraint?
    var centerY: NSLayoutConstraint?
    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    
    public init(top: NSLayoutConstraint? = nil, bottom: NSLayoutConstraint? = nil,
                left: NSLayoutConstraint? = nil, right: NSLayoutConstraint? = nil,
                centerX: NSLayoutConstraint? = nil, centerY: NSLayoutConstraint? = nil,
                width: NSLayoutConstraint? = nil, height: NSLayoutConstraint? = nil) {
        self.top = top
        self.bottom = bottom
        self.left = left
        self.right = right
        self.centerX = centerX
        self.centerY = centerY
        self.width = width
        self.height = height
    }
    
    /// All of the currently configured constraints
    private var availableConstraints: [NSLayoutConstraint] {
        #if swift(>=4.1)
        return [top, bottom, left, right, centerX, centerY, width, height].compactMap {$0}
        #else
        return [top, bottom, left, right, centerX, centerY, width, height].flatMap {$0}
        #endif
    }
    
    /// Activates all of the non-nil constraints
    ///
    /// - Returns: Self
    @discardableResult
    func activate() -> Self {
        NSLayoutConstraint.activate(availableConstraints)
        return self
    }
    
    /// Deactivates all of the non-nil constraints
    ///
    /// - Returns: Self
    @discardableResult
    func deactivate() -> Self {
        NSLayoutConstraint.deactivate(availableConstraints)
        return self
    }
}


/// Keyboard events that can happen. Translates directly to UIKeyboard notifications from UIKit.
public enum KeyboardEvent {
    
    /// Event raised by UIKit's .UIKeyboardWillShow.
    case willShow
    
    /// Event raised by UIKit's .UIKeyboardDidShow.
    case didShow
    
    /// Event raised by UIKit's .UIKeyboardWillShow.
    case willHide
    
    /// Event raised by UIKit's .UIKeyboardDidHide.
    case didHide
    
    /// Event raised by UIKit's .UIKeyboardWillChangeFrame.
    case willChangeFrame
    
    /// Event raised by UIKit's .UIKeyboardDidChangeFrame.
    case didChangeFrame
    
    /// Non-keyboard based event raised by UIKit
    case unknown
    
}

/// An object that observes keyboard notifications such that event callbacks can be set for each notification
open class KeyboardManager: NSObject, UIGestureRecognizerDelegate {
    
    /// A callback that passes a KeyboardNotification as an input
    public typealias EventCallback = (KeyboardNotification)->Void
    
    // MARK: - Properties [Public]
    
    /// A weak reference to a view bounded to the top of the keyboard to act as an InputAccessoryView
    /// but kept within the bounds of the UIViewControllers view
    open weak var inputAccessoryView: UIView?
    
    /// A flag that indicates if a portion of the keyboard is visible on the screen
    private(set) public var isKeyboardHidden: Bool = true
    
    // MARK: - Properties [Private]
    
    /// The NSLayoutConstraintSet that holds the inputAccessoryView to the bottom if its superview
    private var constraints: NSLayoutConstraintSet?
    
    /// A weak reference to a UIScrollView that has been attached for interactive keyboard dismissal
    private weak var scrollView: UIScrollView?
    
    /// The EventCallback actions for each KeyboardEvent. Default value is EMPTY
    private var callbacks: [KeyboardEvent: EventCallback] = [:]
    
    /// The pan gesture that handles dragging on the scrollView
    private var panGesture: UIPanGestureRecognizer?
    
    /// A cached notification used as a starting point when a user dragging the scrollView down
    /// to interactively dismiss the keyboard
    private var cachedNotification: KeyboardNotification?
    
    // MARK: - Initialization
    
    /// Creates a KeyboardManager object an binds the view as fake InputAccessoryView
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    public convenience init(inputAccessoryView: UIView) {
        self.init()
        self.bind(inputAccessoryView: inputAccessoryView)
    }
    
    /// Creates a KeyboardManager object that observes the state of the keyboard
    public override init() {
        super.init()
        addObservers()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - De-Initialization
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Keyboard Observer
    
    /// Add an observer for each keyboard notification
    private func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: UIResponder.keyboardDidChangeFrameNotification,
                                               object: nil)
    }
    
    // MARK: - Mutate Callback Dictionary
    
    /// Sets the EventCallback for a KeyboardEvent
    ///
    /// - Parameters:
    ///   - event: KeyboardEvent
    ///   - callback: EventCallback
    /// - Returns: Self
    @discardableResult
    open func on(event: KeyboardEvent, do callback: EventCallback?) -> Self {
        callbacks[event] = callback
        return self
    }
    
    /// Constrains the inputAccessoryView to the bottom of its superview and sets the
    /// .willChangeFrame and .willHide event callbacks such that it mimics an InputAccessoryView
    /// that is bound to the top of the keyboard
    ///
    /// - Parameter inputAccessoryView: The view to bind to the top of the keyboard but within its superview
    /// - Returns: Self
    @discardableResult
    open func bind(inputAccessoryView: UIView) -> Self {
        
        guard let superview = inputAccessoryView.superview else {
            fatalError("inputAccessoryView must have a superview")
        }
        self.inputAccessoryView = inputAccessoryView
        inputAccessoryView.translatesAutoresizingMaskIntoConstraints = false
        constraints = NSLayoutConstraintSet(
            bottom: inputAccessoryView.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            left: inputAccessoryView.leftAnchor.constraint(equalTo: superview.leftAnchor),
            right: inputAccessoryView.rightAnchor.constraint(equalTo: superview.rightAnchor)
            ).activate()
        
        callbacks[.willShow] = { [weak self] (notification) in
            let keyboardHeight = notification.endFrame.height
            guard
                self?.isKeyboardHidden == false,
                self?.constraints?.bottom?.constant == 0,
                notification.isForCurrentApp else { return }
            self?.animateAlongside(notification) {
                self?.constraints?.bottom?.constant = -keyboardHeight
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        callbacks[.willChangeFrame] = { [weak self] (notification) in
            let keyboardHeight = notification.endFrame.height
            guard
                self?.isKeyboardHidden == false,
                notification.isForCurrentApp else { return }
            self?.animateAlongside(notification) {
                self?.constraints?.bottom?.constant = -keyboardHeight
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        callbacks[.willHide] = { [weak self] (notification) in
            guard notification.isForCurrentApp else { return }
            self?.animateAlongside(notification) { [weak self] in
                self?.constraints?.bottom?.constant = 0
                self?.inputAccessoryView?.superview?.layoutIfNeeded()
            }
        }
        return self
    }
    
    /// Adds a UIPanGestureRecognizer to the scrollView to enable interactive dismissal`
    ///
    /// - Parameter scrollView: UIScrollView
    /// - Returns: Self
    @discardableResult
    open func bind(to scrollView: UIScrollView) -> Self {
        self.scrollView = scrollView
        self.scrollView?.keyboardDismissMode = .interactive // allows dismissing keyboard interactively
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer))
        recognizer.delegate = self
        self.panGesture = recognizer
        self.scrollView?.addGestureRecognizer(recognizer)
        return self
    }
    
    // MARK: - Keyboard Notifications
    
    /// An observer method called last in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidShow(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didShow]?(keyboardNotification)
    }
    
    /// An observer method called last in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidHide(notification: NSNotification) {
        isKeyboardHidden = true
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didHide]?(keyboardNotification)
    }
    
    /// An observer method called third in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardDidChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.didChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called first in the lifecycle of a keyboard becoming visible/hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillChangeFrame(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willChangeFrame]?(keyboardNotification)
        cachedNotification = keyboardNotification
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming visible
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillShow(notification: NSNotification) {
        isKeyboardHidden = false
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willShow]?(keyboardNotification)
    }
    
    /// An observer method called second in the lifecycle of a keyboard becoming hidden
    ///
    /// - Parameter notification: NSNotification
    @objc
    open func keyboardWillHide(notification: NSNotification) {
        guard let keyboardNotification = KeyboardNotification(from: notification) else { return }
        callbacks[.willHide]?(keyboardNotification)
    }
    
    // MARK: - Helper Methods
    
    private func animateAlongside(_ notification: KeyboardNotification, animations: @escaping ()->Void) {
        UIView.animate(withDuration: notification.timeInterval, delay: 0, options: [notification.animationOptions, .allowAnimatedContent, .beginFromCurrentState], animations: animations, completion: nil)
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    /// Starts with the cached KeyboardNotification and calculates a new endFrame based
    /// on the UIPanGestureRecognizer then calls the .willChangeFrame EventCallback action
    ///
    /// - Parameter recognizer: UIPanGestureRecognizer
    @objc
    open func handlePanGestureRecognizer(recognizer: UIPanGestureRecognizer) {
        guard
            var keyboardNotification = cachedNotification,
            case .changed = recognizer.state,
            let view = recognizer.view,
            let window = UIApplication.shared.windows.first
            else { return }
        
        let location = recognizer.location(in: view)
        let absoluteLocation = view.convert(location, to: window)
        var frame = keyboardNotification.endFrame
        frame.origin.y = max(absoluteLocation.y, window.bounds.height - frame.height)
        frame.size.height = window.bounds.height - frame.origin.y
        keyboardNotification.endFrame = frame
        callbacks[.willChangeFrame]?(keyboardNotification)
    }
    
    /// Only receive a UITouch event when the scrollView's keyboard dismiss mode is interactive
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return scrollView?.keyboardDismissMode == .interactive
    }
    
    /// Only recognice simultaneous gestures when its the panGesture
    open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer === panGesture
    }
    
}


import UIKit

/// An object containing the key animation properties from NSNotification
public struct KeyboardNotification {
    
    // MARK: - Properties
    
    /// The event that triggered the transition
    public let event: KeyboardEvent
    
    /// The animation length the keyboards transition
    public let timeInterval: TimeInterval
    
    /// The animation properties of the keyboards transition
    public let animationOptions: UIView.AnimationOptions
    
    /// iPad supports split-screen apps, this indicates if the notification was for the current app
    public let isForCurrentApp: Bool
    
    /// The keyboards frame at the start of its transition
    public var startFrame: CGRect
    
    /// The keyboards frame at the beginning of its transition
    public var endFrame: CGRect
    
    /// Requires that the NSNotification is based on a UIKeyboard... event
    ///
    /// - Parameter notification: KeyboardNotification
    public init?(from notification: NSNotification) {
        guard notification.event != .unknown else { return nil }
        self.event = notification.event
        self.timeInterval = notification.timeInterval ?? 0.25
        self.animationOptions = notification.animationOptions
        self.isForCurrentApp = notification.isForCurrentApp ?? true
        self.startFrame = notification.startFrame ?? .zero
        self.endFrame = notification.endFrame ?? .zero
    }
    
}


internal extension NSNotification {
    
    var event: KeyboardEvent {
        switch self.name {
        case UIResponder.keyboardWillShowNotification:
            return .willShow
        case UIResponder.keyboardDidShowNotification:
            return .didShow
        case UIResponder.keyboardWillHideNotification:
            return .willHide
        case UIResponder.keyboardDidHideNotification:
            return .didHide
        case UIResponder.keyboardWillChangeFrameNotification:
            return .willChangeFrame
        case UIResponder.keyboardDidChangeFrameNotification:
            return .didChangeFrame
        default:
            return .unknown
        }
    }
    
    var timeInterval: TimeInterval? {
        guard let value = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else { return nil }
        return TimeInterval(truncating: value)
    }
    
    var animationCurve: UIView.AnimationCurve? {
        guard let index = (userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue else { return nil }
        guard index >= 0 && index <= 3 else { return .linear }
        return UIView.AnimationCurve.init(rawValue: index) ?? .linear
    }
    
    var animationOptions: UIView.AnimationOptions {
        guard let curve = animationCurve else { return [] }
        switch curve {
        case .easeIn:
            return .curveEaseIn
        case .easeOut:
            return .curveEaseOut
        case .easeInOut:
            return .curveEaseInOut
        case .linear:
            return .curveLinear
        }
    }
    
    var startFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var endFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var isForCurrentApp: Bool? {
        return (userInfo?[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
    }
}
