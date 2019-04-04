//
//  CustomTabBarController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-14.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import CoreLocation


class TabBarController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
    //SETUP Custom view controllers
        
        
        let homeDataSourceController = HomeDatasourceController()
        let homeNavController = UINavigationController(rootViewController: homeDataSourceController)
        
        homeNavController.tabBarItem.title = "Home"
        homeNavController.tabBarItem.image = UIImage(named: "home_trash")
        
        //Dummy controllers
        let viewController = UIViewController()
        
        
        let lurkRealController = LurkController()
        let lurkController = UINavigationController(rootViewController: lurkRealController)
        lurkController.tabBarItem.title = "Lurk"
        lurkController.tabBarItem.image = UIImage(named: "lurk_trash")
        
        
        
//        let ok = self.tabBarController?.viewControllers![0] as! HomeDatasourceController
        
        let profileController = ProfileController()
//        profileController.currentLocation = ok.currentLocation
        let meController = UINavigationController(rootViewController: profileController)
        meController.tabBarItem.title = "Me"
        meController.tabBarItem.image = UIImage(named: "me_trash")
        
        
        let moreController = UINavigationController(rootViewController: viewController)
        moreController.tabBarItem.title = "More"
        moreController.tabBarItem.image = UIImage(named: "more_trash")
        
        viewControllers = [homeNavController, lurkController, meController, moreController]
        
        
        
    
    }
    
}


