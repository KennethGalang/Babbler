//
//  CreateChatroomController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-25.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents
import UIKit
import CoreLocation
import TRON
import SwiftyJSON
import Firebase
import FirebaseFirestore


class CreateChatroomController: UIViewController{
    
    var currentLocationLatitude = 5.0
    var currentLocationLongitude = 5.0
    static var imageSelf: UIImage!
    @IBOutlet var cameraButton: UIButton!
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextField!
    @IBOutlet var emojiField: EmojiTextField!
    @IBOutlet var distanceRadius: UITextField!
    static var didTakePic = false
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Current Location in CreateChatroomController: \(self.currentLocationLatitude), \(self.currentLocationLongitude)")
        CreateChatroomController.didTakePic = false
        //When I add uploading images, anchor the titleField to the image section
        //Also, fix these anchors up eventually (and everywhere probably..) going to need to anchor according to iPhone screen size rather than SET sizes
        inputItems()
    }
    
    func inputItems(){
        distanceRadius.anchor(nil, left: nil, bottom: titleField.topAnchor, right: nil, topConstant: 275 ,leftConstant: 8,
                                            bottomConstant: 10, rightConstant: 0, widthConstant: 300, heightConstant: 30)
        distanceRadius.keyboardType = UIKeyboardType.decimalPad
        distanceRadius.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleField.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 275 ,leftConstant: 8,
                          bottomConstant: 5, rightConstant: 0, widthConstant: 176, heightConstant: 30)
        titleField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descField.anchor(titleField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8,leftConstant: 8,
                         bottomConstant: 0, rightConstant: 0, widthConstant: 301, heightConstant: 85)
        descField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emojiField.anchor(descField.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8,leftConstant: 8,
                          bottomConstant: 0, rightConstant: 0, widthConstant: 56, heightConstant: 30)
        
        emojiField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createButton.frame = CGRect(x: UIScreen.main.bounds.width - 110,y: 40,width: 90,height: 30)
        exitButton.frame = CGRect(x: UIScreen.main.bounds.width-300 ,y: 40,width: 90,height: 30)
        
        exitButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 20, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 30)
        
        imageView.image = UIImage(named: "perth_image")
        CreateChatroomController.imageSelf = UIImage(named: "perth_image")
        
        imageView.anchor(exitButton.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8,leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 100, heightConstant: 148)
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.anchor(imageView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 8,leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 30, heightConstant: 30)
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.backgroundColor = .black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if CreateChatroomController.didTakePic == true{
            
            let tempData = CreateChatroomController.imageSelf.jpeg(.lowest)
            let tempVar = UIImage(data: tempData!)
            
            imageView.image = tempVar
            print("Count original: ", CreateChatroomController.imageSelf.jpeg(.highest)!.count)
            print("Count after vconversion: ", tempVar!.jpeg(.highest)!.count)
            if let imageData = CreateChatroomController.imageSelf.jpeg(.lowest) {
                print("Count after jpeg:", imageData.count)
            }
            
        }
    }
    
    @IBAction func goToCamera(_ sender: Any) {
        print("go to camera")
    }
    
    @IBAction func createChatroom(_ sender: Any) {
        let db = Firestore.firestore()
        var variable: DocumentReference? = nil
        
        if (CreateChatroomController.didTakePic == false){
            print ("pick default pic")
        }
        
        if ((titleField.text != "") && (descField.text != "") && (emojiField.text != "") && (emojiField.text?.isSingleEmoji)!){
            variable = db.collection("chatrooms").addDocument(data: [
                "title": titleField.text!,
                "desc": descField.text!,
                "emoji": emojiField.text!,
                "latitude": self.currentLocationLatitude,
                "longitude": self.currentLocationLongitude,
                "distanceRadius": Double(distanceRadius.text!),
                "URL": "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png"
                //Ok , I need to add this, because
                //If I don't, homedatasourcecontroller fetchhomefeed will be triggered, WITHOUT a URL - this fcks with grabbing a URL from internet
                //it crashes the program, so I need this, and the modify will change it to the actual URL
                ])
            {err in
                if err != nil{
                        print("error")
                    }
                    else{
                        print("added")
                    }
            }
            
            print("o1")
            let documentID = String(variable!.documentID)
            print("o2")
            let storage = Storage.storage()
            print("o3")
            let storageRef = storage.reference()
            print("o4")
            let imagesRef = storageRef.child("chatroomImages")
            print("o5")
            let imageR = CreateChatroomController.imageSelf
            print("o6")
            //
            
            
            let randomKey = "randomKey"
            print("o7")
            let chatroomImageRef = imagesRef.child(documentID)
            print("o8")
            let data = imageR!.jpegData(compressionQuality: 0.3)
//            let data = imageR!.pngData()
            
            print("o9")
            let uploadTask = chatroomImageRef.putData(data!, metadata: nil) { (metadata, error) in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("Lmfao wtf")
                    return
                }
                
            
//                 Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                chatroomImageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        print("Lmfao wtf2")
                        return
                    }
                    print("Below is the download URL")
                    
                    print(downloadURL)
                    
                    db.collection("chatrooms").document(variable!.documentID).setData(["URL": downloadURL.absoluteString ], merge: true)
                    
                    
                    
                    UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
                    print("SAVING CAMERA IMAGE")
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
//            let chatroom = Chatroom(title: titleField.text!, desc: descField.text!, emoji: emojiField.text!, documentID: documentID!, latitude: self.currentLocationLatitude, longitude: self.currentLocationLongitude , distanceToUser: 0.0, distanceRadius: 0.0 , chatImage: UIImage(named: "perth_image")!)
//            let chatroom = Chatroom(title: titleField.text!, desc: descField.text!, emoji: emojiField.text!, documentID: documentID!, latitude: self.currentLocationLatitude, longitude: self.currentLocationLongitude , distanceToUser: 0.0 , chatImage: UIImage(named: "perth_image")!)
            
            //Code
            //Switch view controller to ChatroomController (specific to documentID)
            
//            let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
            
//            let vc = storyboard.instantiateViewController(withIdentifier: "Chatroom") as? ChatroomController
//            vc?.chatroom = chatroom
//            vc?.documentID = documentID!
//            self.navigationController?.pushViewController(vc!, animated: true)
            
            
            
            
//            UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
//            print("SAVING CAMERA IMAGE")
            
//            dismiss(animated: true, completion: nil)
            
            
        }
        else{
            print("THATTTT AINT NO SINGLE EMOJI!")
        }
        
        
    }
    
    @IBAction func exitView(_ sender: Any) {
        
        print("Exiting chat creation room")
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}




//Emoji for Keyboard
class EmojiTextField: UITextField {
    
    override var textInputMode: UITextInputMode? {
        for mode in UITextInputMode.activeInputModes {
            if mode.primaryLanguage == "emoji" {
                return mode
            }
        }
        return nil
    }
}
