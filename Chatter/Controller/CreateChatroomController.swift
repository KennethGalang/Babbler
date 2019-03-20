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
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextField!
    @IBOutlet var emojiField: EmojiTextField!
    @IBOutlet var distanceRadius: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Current Location in CreateChatroomController: \(self.currentLocationLatitude), \(self.currentLocationLongitude)")
        //When I add uploading images, anchor the titleField to the image section
        //Also, fix these anchors up eventually (and everywhere probably..) going to need to anchor according to iPhone screen size rather than SET sizes
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
        
        
    }
    
    
    @IBAction func createChatroom(_ sender: Any) {
        let db = Firestore.firestore()
        var variable: DocumentReference? = nil
        
        if ((titleField.text != "") && (descField.text != "") && (emojiField.text != "") && (emojiField.text?.isSingleEmoji)!){
            variable = db.collection("chatrooms").addDocument(data: [
                "title": titleField.text!,
                "desc": descField.text!,
                "emoji": emojiField.text!,
                "latitude": self.currentLocationLatitude,
                "longitude": self.currentLocationLongitude,
                "distanceRadius": Double(distanceRadius.text!)
                ])
                
            {err in
                if err != nil{
                        print("error")
                    }
                    else{
                        print("added")
                    }
            }
            
            let documentID = variable?.documentID
//            let chatroom = Chatroom(title: titleField.text!, desc: descField.text!, emoji: emojiField.text!, documentID: documentID!, latitude: self.currentLocationLatitude, longitude: self.currentLocationLongitude , distanceToUser: 0.0, distanceRadius: 0.0 , chatImage: UIImage(named: "perth_image")!)
//            let chatroom = Chatroom(title: titleField.text!, desc: descField.text!, emoji: emojiField.text!, documentID: documentID!, latitude: self.currentLocationLatitude, longitude: self.currentLocationLongitude , distanceToUser: 0.0 , chatImage: UIImage(named: "perth_image")!)
            
            //Code
            //Switch view controller to ChatroomController (specific to documentID)
            
//            let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
            
//            let vc = storyboard.instantiateViewController(withIdentifier: "Chatroom") as? ChatroomController
//            vc?.chatroom = chatroom
//            vc?.documentID = documentID!
//            self.navigationController?.pushViewController(vc!, animated: true)
            
            dismiss(animated: true, completion: nil)
            
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
