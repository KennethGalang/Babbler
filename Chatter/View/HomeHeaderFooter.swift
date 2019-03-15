//
//  Cells.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-13.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents

class HomeHeader: DatasourceCell {
    override func setupViews() {
        super.setupViews()
        backgroundColor = .blue
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
    }
}

class HomeFooter: DatasourceCell{
    override func setupViews() {
        super.setupViews()
        backgroundColor = .green
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
    }
}


