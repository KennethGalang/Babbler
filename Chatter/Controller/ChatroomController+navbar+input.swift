//
//  ChatroomController+navbar.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-05.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

extension ChatroomUIViewController {
    
    func setupNavigationBarItems() {
        
        navigationController?.navigationBar.backgroundColor = UIColor(r: 204, g: 255, b: 255)
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 34, height: 34)) // Add your frames
        let titleImageView = UIImageView(image: UIImage(named: "radius_image")) // Give your image name
        titleImageView.frame = titleView.bounds
        titleView.addSubview(titleImageView)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
    }
    
    //Header Begin
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        //        if kind == UICollectionView.elementKindSectionHeader{
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
        header.backgroundColor = .red
        return header
        //        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
    //Header End
    
    //Cell begin
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
        section: Int) -> Int{
        return self.chatMessages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
        IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatroomMessageCell
        //        cell.backgroundColor = .green
        let message = self.chatMessages[indexPath.item]
        
        //        Add emoji to it eventually?
        //Height
        cell.chatMessageText.text =  message.username + ": " + message.text
        
        //If Messaged ID = FIRATH.auth()?.currentUser?.uid then do some things, make chat bubble be on the right
        //https://www.youtube.com/watch?v=JK7pHuSfLyA&list=PL0dzCUj1L5JEfHqwjBV0XFb9qx9cGXwkq&index=14
        //Maybe even somehow clamp the bitmoji face on the right side of the thing ?
        
        //Width
        let text = chatMessages[indexPath.item].username + ": " + chatMessages[indexPath.item].text
        
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(text: text).width + 15
        return cell
    }
    
    private func estimatedFrameForText(text: String) -> CGRect{
        let size = CGSize(width: view.frame.width, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        //Before 13, it was 12... it was perfect, if not perfect, then fix stuff up lol
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], context: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        
        //getting estimated height
        let text = chatMessages[indexPath.item].username + ": " + chatMessages[indexPath.item].text
        if  text != "" {
            height = estimatedFrameForText(text: text).height + 20
        }
        
        return CGSize(width:view.frame.width, height: height)
    }
    //Cell end
    
    @objc func handleSend(){
        //        var string = ""
        //        string = inputTextField.text ?? ""
        //        print(string)
        
        let db = Firestore.firestore()
        var variable: DocumentReference? = nil
        if (inputTextField.text != ""){
            variable = db.collection("chatrooms").document(self.documentID).collection("messages").addDocument(data: [
                "timestamp": Int(Date().timeIntervalSince1970),
                "username": "👲DummyUsername",
                "text": inputTextField.text,
                "reactions": ["😊","😢"]
                ])
                
            {err in
                if err != nil{
                    print("error")
                }
                else{
                    print("added")
                }
            }
            _ = variable?.documentID
        }else{
            print("EMPTY MESSAGE!")
        }
        
        inputTextField.text = ""
    }
    
    
    //Input components end
}

