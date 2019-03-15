//
//  HomeDatasource.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-13.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents
import Firebase
import FirebaseFirestore

class HomeDatasource: Datasource {
    var chatrooms: [Chatroom] = []
    
    required init( chatroom : [Chatroom]){
        self.chatrooms = chatroom
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [HomeHeader.self]
    }
    
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [HomeFooter.self]
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [HomeCell.self]
    }
    
    
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return chatrooms[indexPath.item]
    }
    
    override func numberOfSections() -> Int {
        return 1
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return chatrooms.count
    }
    
    
    
}
