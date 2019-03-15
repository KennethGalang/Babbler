//
//  HomeDatasourceController+navbar.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-19.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit

extension HomeDatasourceController {
    func setupNavigationBarItems() {
        
        navigationController?.navigationBar.backgroundColor = UIColor(r: 204, g: 255, b: 255)
        
        let titleView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 34, height: 34)) // Add your frames
        let titleImageView = UIImageView(image: UIImage(named: "radius_image")) // Give your image name
        titleImageView.frame = titleView.bounds
        titleView.addSubview(titleImageView)
        titleImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = titleView
        
        let scoreText = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 120, height: 34))
        let scoreTextView = UILabel()
        scoreTextView.text = "6969"
        scoreTextView.frame = scoreText.bounds
        scoreText.addSubview(scoreTextView)
        scoreText.contentMode = .scaleAspectFit
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: scoreText)
        
        
        let createBut = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 34, height: 34))
        let createButton = UIButton(type: .system)
        createButton.setImage(UIImage(named: "enter")?.withRenderingMode(.alwaysOriginal), for: .normal)
        createButton.frame = createBut.bounds
        createBut.addSubview(createButton)
        createButton.contentMode = .scaleAspectFit
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: createBut)
        createButton.addTarget(self, action: #selector(createChatroom), for: .touchUpInside)
        
        
        
        
        
        //NAV BAR line
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        let navBarSeparatorView = UIView()
        navBarSeparatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        view.addSubview(navBarSeparatorView)
        navBarSeparatorView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0,
                                   leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        
    }
    
    
    
}

