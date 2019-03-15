//
//  CreateChatroomDatasource.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-25.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//


import UIKit

struct ChatMessage{
//    let date: NSNumber?
    let username: String
    let text: String
    let timestamp: NSNumber?
    let reactions: [String] //List of Emojis .. future implementation
    //Maybe have like 7 reactions kind of like facebook's ? 
}
