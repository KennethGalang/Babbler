//
//  CameraController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-03-23.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseFirestore
//import FirebaseStorage
//import FirebaseUI

class CameraController: UIViewController{
    let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setTitle("EXIT", for: .normal)
        exitButton.tintColor = .blue
        exitButton.backgroundColor = .white
//        exitButton.setTitleColor(.black, for: .normal)
        exitButton.isUserInteractionEnabled = true
        return exitButton
    }()
    
    //For now, have it just in the middle of it, but eventually, gonna have a containerview at bottom similar to camera app lol
    //Eventually have a cancel like thing too lol, like snapchat? But make it clean or something lol
    @IBOutlet var takePicButton: UIButton!
    let containerView = UIView()
   
    
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    var image: UIImage?
    override func viewDidLoad(){
        super.viewDidLoad()
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        startRunningCaptureSession()
        addObjects()
    }
    func setupCaptureSession(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    func setupDevice(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
            
        }
        currentCamera = backCamera
    }
    func setupInputOutput(){
        do{
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            captureSession.addInput(captureDeviceInput)
            photoOutput = AVCapturePhotoOutput()
            photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
            captureSession.addOutput(photoOutput!)
        }catch{
            print("This is error Here: ", error)
        }
    }
    func setupPreviewLayer(){
        cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraPreviewLayer?.frame = self.view.frame
        self.view.layer.insertSublayer(cameraPreviewLayer!, at: 0)
    }
    func startRunningCaptureSession(){
        captureSession.startRunning()
    }
    
    func addObjects(){
        view.backgroundColor = .black
        view.addSubview(containerView)
        
        containerView.backgroundColor = UIColor.cyan
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        //Add constraints x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(exitButton)
        exitButton.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        exitButton.addTarget(self, action: #selector(exitPage), for: .touchUpInside)
        
        view.addSubview(takePicButton)
        takePicButton.layer.borderWidth = 7.0
        takePicButton.layer.borderColor = (UIColor( red: 255.0, green: 255.0, blue:255, alpha: 1.0 )).cgColor
        takePicButton.backgroundColor = .clear
        takePicButton.isUserInteractionEnabled = true
        takePicButton.layer.cornerRadius = 45
        takePicButton.anchor(nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 40, rightConstant: 8, widthConstant: 90, heightConstant: 90)
        takePicButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    @IBAction func takePictAction(_ sender: Any) {
        let settings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: settings, delegate: self)
//        performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPhoto_Segue" {
            let previewVC = segue.destination as! PreviewPicture
//            let imageReceive = self.image
//            let imageReal = UIImageView(image: imageReceive)
            previewVC.imageReceive = self.image
        }
    }
    
    
    @objc func exitPage(_ sender: Any) {
        print("Exiting camera page")
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension CameraController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(){
            // Photo/data in form of data object
//            print(imageData)
            image = UIImage(data: imageData)
            
            performSegue(withIdentifier: "showPhoto_Segue", sender: nil)
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PreviewPicture: UIViewController{
    
    @IBOutlet var photo: UIImageView!
    var imageReceive: UIImage!
    
    let containerView = UIView()
    let exitButton: UIButton = {
        let exitButton = UIButton(type: .system)
        exitButton.setTitle("Cancel", for: .normal)
        exitButton.tintColor = .blue
        exitButton.backgroundColor = .white
        //        exitButton.setTitleColor(.black, for: .normal)
        exitButton.isUserInteractionEnabled = true
        return exitButton
    }()
    let saveButton: UIButton = {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.tintColor = .blue
        saveButton.backgroundColor = .white
        //        exitButton.setTitleColor(.black, for: .normal)
        saveButton.isUserInteractionEnabled = true
        return saveButton
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        photo.image = self.imageReceive
        addObjects()
        
        
//        photo.image = self.image
    }
    func addObjects(){
//        view.backgroundColor = .black
//        let imageView = UIImageView(image: imageReceive)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
//        view.addSubview(imageView)
//
//        imageView.widthAnchor.constraint(equalToConstant: view.frame.height).isActive = true
//        imageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        imageView.topAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: view.frame.height).isActive = true
//        imageView.contentMode = .scaleAspectFill
        
        containerView.backgroundColor = UIColor.cyan
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        //Add constraints x,y,w,h
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(exitButton)
        exitButton.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        exitButton.addTarget(self, action: #selector(exitPage), for: .touchUpInside)
        
        view.addSubview(saveButton)
        saveButton.anchor(containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 8, leftConstant: 8, bottomConstant: 8, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        saveButton.addTarget(self, action: #selector(savePage), for: .touchUpInside)
        
    }
    
    @objc func exitPage(_ sender: Any) {
        print("Exiting camera page")
        dismiss(animated: false, completion: nil)
    }
    @objc func savePage(_ sender: Any) {
//        UIImageWriteToSavedPhotosAlbum(self.imageReceive, nil, nil, nil)
//        print("SAVING CAMERA IMAGE")
//        CreateChatroomController.imageSelf =  self.imageReceive
        CreateChatroomController.didTakePic = true
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imagesRef = storageRef.child("chatroomImages")
        let imageR = self.imageReceive
//
        
        let randomKey = "randomKey"
        let chatroomImageRef = imagesRef.child(randomKey)
//        let data = imageR
        let data = imageR!.pngData()
        
        let uploadTask = chatroomImageRef.putData(data!, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                print("Lmfao wtf")
                return
            }
            
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            chatroomImageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    print("Lmfao wtf2")
                    return
                }
                print(downloadURL)
            }
        }
        
        let pathReference = storage.reference(withPath: "chatroomImages/randomKey")
        pathReference.getData(maxSize: 1 * 10240 * 10240) { data, error in
            if let error = error {
                // Uh-oh, an error occurred!
                print("WOOWWWW error?", error)
            } else {
                // Data for "chatroomImages/randomKey" is returned
                let imageFromDatabase = UIImage(data: data!)
                let imageRotated = imageFromDatabase!.rotate(radians: .pi/2) // Rotate 90 degrees
                CreateChatroomController.imageSelf = imageRotated
                
                self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
        }
        
        
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
 
}

extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
