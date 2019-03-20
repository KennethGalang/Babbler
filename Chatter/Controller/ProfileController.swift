//
//  ProfileController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-20.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import MapKit


class ProfileController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addItems()
        
        
//        mapView.delegate = (self as! MKMapViewDelegate)
        
        
        
        
    }
    
    func addItems(){
        let myView = UIView()
        self.view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
//        mapView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
        
    }
    
}
