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
    
    let mapView = MKMapView()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .green
        
        
        
//        mapView.delegate = (self as! MKMapViewDelegate)
        
        
    }
    
    @objc func buttonAction(){
        print("button pressed")
        print(currentLocation)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let username: UILabel = {
        let textView = UILabel()
        textView.text = "👲Dummy Username"
        textView.textAlignment = .center
        textView.font = UIFont.boldSystemFont(ofSize: 15)
        return textView
    }()
    
    let dummy1: UILabel = {
        let textView = UILabel()
        textView.text = "Score : 696969"
        textView.textAlignment = .center
        return textView
    }()
    let dummy2: UITextView = {
        let textView = UITextView()
        textView.text = "This is just a dummy description and a tester"
        textView.textAlignment = .center
        //For some reason, this goes to white.. conclusion: textView isn't seethrough
        textView.backgroundColor = .green
        return textView
    }()
    let dummy3: UILabel = {
        let textView = UILabel()
        textView.text = "This design is whack but eventually I'll think of something sexc"
        textView.font = UIFont.boldSystemFont(ofSize: 11)
        textView.textAlignment = .center
        return textView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentLocation = HomeDatasourceController.currentLocation
        
        

        mapView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapView)
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 49).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 49).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: view.frame.height/3).isActive = true
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: self.currentLocation.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        mapView.setRegion(region, animated: true)
        
        // Omg.. add nearby chatrooms with this !!
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.coordinate = self.currentLocation.coordinate
        mapView.addAnnotation(annotation)
        
        
        mapView.delegate = self //Huh lol
        
        view.addSubview(username)
        
        username.anchor(mapView.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: view.frame.width, heightConstant: 40)
        
        //Temporary
        view.addSubview(dummy1)
        view.addSubview(dummy2)
        view.addSubview(dummy3)
        dummy1.anchor(username.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: view.frame.width, heightConstant: 40)
        dummy2.anchor(dummy1.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: view.frame.width, heightConstant: 40)
        dummy3.anchor(dummy2.bottomAnchor, left: nil, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 8, widthConstant: view.frame.width, heightConstant: 40)
        
    }

}
