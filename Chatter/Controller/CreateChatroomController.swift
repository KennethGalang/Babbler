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
    
    
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    @IBAction func exitView(_ sender: Any) {

        print("Exiting chat creation room")
        
        
        
        //Exits page
        dismiss(animated: true, completion: nil)

    }
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var descField: UITextField!
    @IBOutlet var emojiField: UITextField!
    
    
    @IBAction func createChatroom(_ sender: Any) {
        let db = Firestore.firestore()
        var variable: DocumentReference? = nil
        
        if ((titleField.text != "") && (descField.text != "") && (emojiField.text != "") && (emojiField.text?.isSingleEmoji)!){
            variable = db.collection("chatrooms").addDocument(data: [
                "title": titleField.text!,
                "desc": descField.text!,
                "emoji": emojiField.text!
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
            //MAYYYYBEEEE Right here, edit the view controller of the one chat room and add this room ? Idk
            //Probably going to have to create this then go to main home data source view THEN go to chat room
            
            //Code
            //Switch view controller to ChatroomController (specific to documentID)
            
            dismiss(animated: true, completion: nil)
            
        }
        else{
            print("THATTTT AINT NO SINGLE EMOJI!")
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("@@@@@@@@", "l".isSingleEmoji)
        print("SINGLE ! ", "😋".isSingleEmoji)
        print("TRIPLE!", "😋😋😋".isSingleEmoji)
        //When I add uploading images, anchor the titleField to the image section
        titleField.anchor(view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 275 ,leftConstant: 8,
        bottomConstant: 0, rightConstant: 0, widthConstant: 176, heightConstant: 30)
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
}


