//
//  WordCell.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-05.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit

class ChatroomMessageCell: UICollectionViewCell{
    override init(frame: CGRect){
        super.init(frame: frame)
        setUpView()
    }

    let chatMessageText: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
//        textView.text = "TES TEST TES"
        textView.font = UIFont.systemFont(ofSize: 13)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        let username = UITextView()
        return textView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        //Not sure about colours yet.. do ui in the end !
        view.backgroundColor = UIColor(r: 0, g: 137, b: 249)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    
    
    

    
    func setUpView(){
//        self.backgroundColor = .yellow
        addSubview(bubbleView)
        addSubview(chatMessageText)
        chatMessageText.isUserInteractionEnabled = false
        
        
        chatMessageText.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 1).isActive = true
        chatMessageText.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        chatMessageText.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: 1).isActive = true
        chatMessageText.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //If chatMessageText.ID or whatever is equal to self.username, then anchor it to the right? or use isActive variables to = false or true for each one ?
//        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        bubbleView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: frame.width-24).isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: frame.width-24)
        bubbleWidthAnchor?.isActive = true
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
