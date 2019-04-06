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


class Items: UIViewController {
    static let sharedInstance = Items()
    var array = [String]()
    
    struct GlobalVariable{
        static var myString = String()
    }
}

class HomeDatasourceController: DatasourceController, CLLocationManagerDelegate{
    let locationManager:CLLocationManager = CLLocationManager()
    var check = false
    var checkForFetchLock = false
    static var currentLocation = CLLocation(latitude: 5.0, longitude: 5.0)
    
    var importantDatasource = HomeDatasource(chatroom: [])
    //Using a list for chatrooms because I need dat index []
    var chatroom_full = [Chatroom]()
    //currentDocumentID Could cause some problems in future.. be careful of it
    var listOfDocumentID = [String]()
    
//    SharedData.sharedLocation = CLLocation(latitude: 5.0, longitude: 5.0)
//    Items.sharedInstance.array.append("New String")
//    print(Items.GlobalVariable.myString)
    
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
                
                HomeDatasourceController.currentLocation = currentLocationTemp
                print("This is latitude: \(HomeDatasourceController.currentLocation.coordinate.latitude) , and this is longitude: \(HomeDatasourceController.currentLocation.coordinate.longitude)")
                //Updates location, but also, check becomes false- since I moved 50m, home feed will be refreshed by this
//                check = false
                self.importantDatasource = HomeDatasource(chatroom: [])
                self.chatroom_full = [Chatroom]()
                
                fetchHomeFeed()
            }
        }
        //Extra time
        for _ in 1...10000{
            if let location = locations.last{
                if check == false{
                    HomeDatasourceController.currentLocation = location
                }
            }
        }
        
        //Get it ONCE the location
        if let location = locations.last{
            if check == false{
                print("%%%%%%%%%%%%%")
                check = true
                HomeDatasourceController.currentLocation = location
                fetchHomeFeed()
            }
        }
    }

  
    
    func fetchHomeFeed() {
        print("(If false, then goes and fetchHomeFeed is performed) Check for fetch is : ", checkForFetchLock)
        if checkForFetchLock == false{
            checkForFetchLock = true
            //Maybe try to reset everytime chatroomfull is loaded?
            self.importantDatasource = HomeDatasource(chatroom: [])
            self.chatroom_full = [Chatroom]()
            
            let db = Firestore.firestore()
            self.chatroom_full = [Chatroom]()
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
                        print("\n\n@@@@Distance Radius : ",distanceRadiusTemp )
                        let latitude_data = latitudeTemp
                        let longitude_data = longitudeTemp
                        let distanceRadius_data = distanceRadiusTemp
                        
                        let chatroomLocation = CLLocation(latitude: latitude_data, longitude: longitude_data)
                        //chatroomLocation.distance(from: self.currentLocation) is in meters.. so convert it to KM
                        let distance_data = chatroomLocation.distance(from: HomeDatasourceController.currentLocation)/1000
//                        print("Distance Radius: ", distanceRadius_data, " And Distance Data: ", distance_data)
        
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
                            print("Self: ", HomeDatasourceController.currentLocation)
                            print("distance below", distance_data, "LOL\n\n")
                            
                            
                            var chatImage = UIImage(named: "class_image")
                            let storage = Storage.storage()
                            let documentIDString = "chatroomImages/" + String(diff.document.documentID)
                            
                            let pathReference = storage.reference(withPath: documentIDString)
                            pathReference.getData(maxSize: 1 * 10240 * 10240) { data, error in
                                if let error = error {
                                    // Uh-oh, an error occurred!
                                    print("WOOWWWW error?", error)
                                } else {
                                    // Data for "chatroomImages/randomKey" is returned
                                    let imageFromDatabase = UIImage(data: data!)
                                    let imageRotated = imageFromDatabase!.rotate(radians: .pi/2) // Rotate 90 degrees
                                    chatImage = imageRotated
                                    print("HO LEE FUCK TOOK SO LONG MAN in homedatasourcecontroller \(documentIDString)")
                                }
                            }
                            
                            
                            let chatroom = Chatroom(title: title_data , desc: desc_data , emoji: emoji_data, documentID: diff.document.documentID, latitude: latitude_data, longitude: longitude_data, distanceToUser: distance_data, distanceRadius: distanceRadius_data, chatImage: chatImage!)
                            
                            //Check if document ID Exists already, if it does don't make duplicates
                            var isInList = false
                            for chatroom in self.chatroom_full{
                                if chatroom.documentID == diff.document.documentID{
                                    isInList = true
                                }
                            }
                            if isInList == false{
                                self.chatroom_full.append(chatroom)
                                self.chatroom_full.sort(by: { $0.distanceToUser < $1.distanceToUser } )
                                let homeDatasource = HomeDatasource(chatroom: self.chatroom_full)
                                self.importantDatasource = homeDatasource
                                self.datasource = homeDatasource
                            }
//                            self.chatroom_full.append(chatroom)
                            
//                            self.chatroom_full.sort(by: { $0.distanceToUser < $1.distanceToUser } )
//                            let homeDatasource = HomeDatasource(chatroom: self.chatroom_full)
//                            self.importantDatasource = homeDatasource
//                            self.datasource = homeDatasource
                            
                            DispatchQueue.main.async{
                                self.collectionView?.reloadData()
                            }
                            self.checkForFetchLock = false
                        }
                        else{
                            print("Not in chatroom, Eventually, load (similar to twitter) lurkables here under MAIN chatrooms  Yup")
                        }
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
        vc.currentLocationLatitude = Double(HomeDatasourceController.currentLocation.coordinate.latitude)
        vc.currentLocationLongitude = Double(HomeDatasourceController.currentLocation.coordinate.longitude)
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

