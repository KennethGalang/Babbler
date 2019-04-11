//
//  UserCell.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-18.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents
import Kingfisher

class HomeCell: DatasourceCell {
    var text = ""
    
    //Able to access whatever is in Datasource from the cell
    override var datasourceItem: Any?{
        didSet{
            //            print(datasourceItem)
            //Guard downcasts it to let chatroom = datasourceitem, this is because you have to downcast the item to be able to access what datasourceItem contains
            // (can't access stuff from datasourceItem directly, have to access a downcasted version of it)
            guard let chatroom = datasourceItem as? Chatroom else{ return }
            titleLabel.text = chatroom.title
            descTextView.text = chatroom.desc
            descTextView.isEditable = false
            emojiTag.text = chatroom.emoji
            
            chatImageView.image = chatroom.chatImage
            
//            chatImageView.kf.setImage(with: URL(string: chatroom.URL))
            
            distanceTag.text = String(Double(round(1000*chatroom.distanceToUser)/1000)) + "km away"
            //If statement for meters, but if km then put in km 
            radiusTag.text = String(chatroom.distanceRadius) + "km🔘"
//            text = descTextView.text
        }
        
    }
    
    override var isHighlighted: Bool{
        didSet{
            let softYellowColour = UIColor(r: 255, g: 255, b: 170)
            backgroundColor = isHighlighted ? softYellowColour : UIColor.white
            titleLabel.backgroundColor = isHighlighted ? softYellowColour : UIColor.green //Change this eventually Lol
            descTextView.backgroundColor = isHighlighted ? softYellowColour : UIColor.white //Yeah I guess itll be white lol
        }
    }
    
    
    
    
    
    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "class_image")
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST TEST TEST"
        label.backgroundColor = .green
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    
    
    
    let joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "enter"), for: .normal)
        button.backgroundColor = .purple
        button.isUserInteractionEnabled = true
        return button
    }()
    
    
    
    let emojiTag: UILabel = {
        let label = UILabel()
        label.text = "🔥"
        label.textAlignment = .center
        label.backgroundColor = .white
        return label
    }()
    
    let distanceTag: UILabel = {
        let label = UILabel()
        label.text = "L"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 11)
        return label
    }()
    
    let radiusTag: UILabel = {
        let label = UILabel()
        label.text = "L"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 9)
        return label
    }()
    
    let descTextView: UITextView = {
        let textView = UITextView()
        textView.text = "This chatroom contains many lit things, oh yes i like whats happening here. Yup I'm guessing that this is actually extremely more lit"
        //        textView.textAlignment = NSTextAlignment.left
        //        textView.font = UIFont.boldSystemFont(ofSize: 11)
        //        textView.backgroundColor = .cyan
        return textView
    }()
    
    
    
    
    
    override func setupViews() {
        super.setupViews()
        backgroundColor = .white
        
        addSubview(descTextView)
        addSubview(chatImageView)
        addSubview(titleLabel)
        addSubview(joinButton)
        addSubview(emojiTag)
        addSubview(distanceTag)
        addSubview(radiusTag)
        
        descTextView.isUserInteractionEnabled = false
        joinButton.isUserInteractionEnabled = false
//        joinButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        
        
        
        chatImageView.anchor(self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8,leftConstant: 8,
                             bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 74)
        
        titleLabel.anchor(chatImageView.topAnchor, left: chatImageView.rightAnchor, bottom: nil, right: joinButton.leftAnchor , topConstant: 0, leftConstant: 8,
                          bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 20)
        
        descTextView.anchor(titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: joinButton.leftAnchor, topConstant: -4, leftConstant: -4, bottomConstant: 0, rightConstant: 4, widthConstant: 0, heightConstant: 58)
        
        joinButton.anchor(titleLabel.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 0,
                          bottomConstant: 0, rightConstant: 12, widthConstant: 50, heightConstant: 74)
        
        emojiTag.anchor(chatImageView.bottomAnchor , left: self.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 20)
        
        distanceTag.anchor(descTextView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: joinButton.leftAnchor, topConstant: 4, leftConstant: 8,
                           bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        
        radiusTag.anchor(descTextView.bottomAnchor, left: descTextView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: 0, heightConstant: 20)
        
    }
    
//    @objc func buttonAction(_sender: UIButton) {
//
//
//        print(text)
//        print(123421312)
//    }
    
    
    

    
}
