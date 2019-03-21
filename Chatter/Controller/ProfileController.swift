//
//  ProfileController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-20.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ProfileController: UIViewController, MKMapViewDelegate{
    var currentLocation = CLLocation(latitude: 55.0, longitude: 55.0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
        addItems()
        
        
//        mapView.delegate = (self as! MKMapViewDelegate)
        
        
        
        
    }
    
    func addItems(){
        print("Add items")
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
//        let mapView: MKMapView!
        
        
//        let myView = UIView()
//        self.view.addSubview(myView)
//        myView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(mapView)
////        mapView.addConstraint(<#T##constraint: NSLayoutConstraint##NSLayoutConstraint#>)
//
    }
    @objc func buttonAction(){
        print("button pressed")
        print(currentLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.currentLocation = HomeDatasourceController.currentLocation
        
        let mapView = MKMapView()
        
        let leftMargin:CGFloat = 0
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = view.frame.size.height/2
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        // Or, if needed, we can position map in the center of the view
        mapView.center = view.center
        
        mapView.delegate = self //Huh lol
        
        view.addSubview(mapView)
    }

}
