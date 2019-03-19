//
//  HomeDatasourceController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-13.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import LBTAComponents
import UIKit
import CoreLocation
import SwiftyJSON
import Firebase
import FirebaseFirestore

class HomeDatasourceController: DatasourceController, CLLocationManagerDelegate{
    let locationManager:CLLocationManager = CLLocationManager()
    var check = false
    var currentLocation = CLLocation(latitude: 5.0, longitude: 5.0)
    
    var importantDatasource = HomeDatasource(chatroom: [])
    var chatroom_full = [Chatroom]()
    //currentDocumentID Could cause some problems in future.. be careful of it
    var listOfDocumentID = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //Update only after every 50 meters
        locationManager.distanceFilter = 50
        
        collectionView?.backgroundColor = UIColor(r: 232, g: 236, b: 241)
        
        setupNavigationBarItems()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //Continuous location
        for currentLocationTemp in locations {
            if check == true{
                
                self.currentLocation = currentLocationTemp
                print("This is latitude: \(currentLocation.coordinate.latitude) , and this is longitude: \(currentLocation.coordinate.longitude)")
                check = false
            }
        }
        //Extra time
        for _ in 1...10000{
            if let location = locations.last{
                if check == false{
                    self.currentLocation = location
                }
            }
        }
        
        //Get it ONCE the location
        if let location = locations.last{
            if check == false{
                print("%%%%%%%%%%%%%")
                check = true
                self.currentLocation = location
                fetchHomeFeed()
            }
        }
    }


    
    func fetchHomeFeed() {
        
//        var listOfDocumentID = [String]()
        let db = Firestore.firestore()
        
        //Ascend by order of distance (closest will be first), also, maybe have a Scroll up to reload button ?
        //Only if self adds it , will it go right away tho ? Maybe- check if snapshot ADD was made my USERNAME !
        //So whoever created a chatroom, will have its username as DB, also- mod permissions (gotta change DB now)
        db.collection("chatrooms").addSnapshotListener { (querySnapshot, err) in
            
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: )")
                return
            }
            snapshot.documentChanges.forEach {diff in
                if (diff.type == .added){
                    print ("\nNew chatroom Added9999999999\n")
                    var latitudeTemp = 5.0
                    var longitudeTemp = 5.0
                    var distanceRadiusTemp = 5.0
                    if let latitude_data = diff.document.data()["latitude"] as? Double{
                        latitudeTemp = latitude_data
                    }
                    
                    if let longitude_data = diff.document.data()["longitude"] as? Double{
                        longitudeTemp = longitude_data
                    }
                    if let distanceRadius_data = diff.document.data()["distanceRadius"] as? Double{
                        distanceRadiusTemp = distanceRadius_data
                    }
                    let latitude_data = latitudeTemp
                    let longitude_data = longitudeTemp
                    let distanceRadius_data = distanceRadiusTemp
                    
                    let chatroomLocation = CLLocation(latitude: latitude_data, longitude: longitude_data)
                    let distance_data = chatroomLocation.distance(from: self.currentLocation)/1000
                    
                    //If chatroom is in range
                    if (distanceRadius_data - distance_data) > 0 {
                        var titleTemp = ""
                        var descTemp = ""
                        var emojiTemp = ""
                        
                        print("LOL")
                        if let title_data = diff.document.data()["title"] as? String{
                            titleTemp = title_data
                        }
                        if let desc_data = diff.document.data()["desc"] as? String{
                            descTemp = desc_data
                        }
                        if let emoji_data = diff.document.data()["emoji"] as? String{
                            emojiTemp = emoji_data
                        }
                        let title_data = titleTemp
                        let desc_data = descTemp
                        let emoji_data = emojiTemp
                        print("location things: ", chatroomLocation)
                        print("Self: ", self.currentLocation)
                        print("distance below", distance_data, "LOL\n\n")
                        let chatroom = Chatroom(title: title_data , desc: desc_data , emoji: emoji_data, documentID: diff.document.documentID, latitude: latitude_data, longitude: longitude_data, distanceToUser: distance_data, distanceRadius: distance_data, chatImage: UIImage(named: "class_image")!)
                        
                        self.chatroom_full.append(chatroom)
                        
                        self.chatroom_full.sort(by: { $0.distanceToUser < $1.distanceToUser } )
                        let homeDatasource = HomeDatasource(chatroom: self.chatroom_full)
                        self.importantDatasource = homeDatasource
                        self.datasource = homeDatasource
                        
                        DispatchQueue.main.async{
                            self.collectionView?.reloadData()
                        }
                    }
                    else{
                        print("Not in chatroom, Eventually, load (similar to twitter) lurkables here under MAIN chatrooms  Yup")
                    }
                }
                
            }
            
        }
        
        
    }
    
    
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout, sizeForItemAt
        indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: view.frame.width, height: 110)
    }
    
    
    
    
    /////////////Spacing setup for cells 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    /////////////
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    @IBOutlet var home: UIView!
    
    @objc func createChatroom(_sender: UIButton) {
        //Storyboard?
        let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
        //CreateChat is the ID of the view in the storyboard
        let vc = storyboard.instantiateViewController(withIdentifier: "CreateChat") as! CreateChatroomController
        vc.currentLocationLatitude = Double(self.currentLocation.coordinate.latitude)
        vc.currentLocationLongitude = Double(self.currentLocation.coordinate.longitude)
        present(vc, animated: true, completion: nil)
        print("Create Chatroom page")
    }
    
    var ok = ["one", "two", "three", "four" , "five"]
    
    //Go to cell of chat room that is clicked
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CreateChatroomStoryboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Chatroom") as? ChatroomController
//        vc?.chatroom_temp = importantDatasource.chatrooms
        vc?.chatroom = self.importantDatasource.chatrooms[indexPath.row]
        print("$$$$$$$")
        vc?.documentID = self.importantDatasource.chatrooms[indexPath.row].documentID
        let cell = collectionView.cellForItem(at: indexPath)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    
}

