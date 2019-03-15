//
//  CustomTabBarController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-14.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
    //SETUP Custom view controllers
    
        let homeNavController = UINavigationController(rootViewController: HomeDatasourceController())
        
        homeNavController.tabBarItem.title = "Home"
        homeNavController.tabBarItem.image = UIImage(named: "home_trash")
        
        //Dummy controllers
        let viewController = UIViewController()
        let lurkController = UINavigationController(rootViewController: viewController)
        lurkController.tabBarItem.title = "Lurk"
        lurkController.tabBarItem.image = UIImage(named: "lurk_trash")
        
        let meController = UINavigationController(rootViewController: viewController)
        meController.tabBarItem.title = "Me"
        meController.tabBarItem.image = UIImage(named: "me_trash")
        
        let moreController = UINavigationController(rootViewController: viewController)
        moreController.tabBarItem.title = "More"
        moreController.tabBarItem.image = UIImage(named: "more_trash")
        
        viewControllers = [homeNavController, lurkController, meController, moreController]
    
    }
    
}


