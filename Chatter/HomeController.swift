//
//  HomeController.swift
//  Chatter
//
//  Created by Kenneth Galang on 2019-02-11.
//  Copyright © 2019 Kenneth Galang. All rights reserved.
//


//import UIKit
//
//class WordCell: UICollectionViewCell{
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        setUpView()
//    }
//
//    let wordLabel: UILabel = {
//        let label = UILabel()
//        label.text = "TES TEST TES"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//
//    }()
//
//    func setUpView(){
//        backgroundColor = .yellow
//        addSubview(wordLabel)
//        wordLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        wordLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        wordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        wordLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
//
//    let cellId = "cellId"
//    let headerId = "headerId"
//    let footerId = "footerId"
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView?.backgroundColor = .blue
//        //Put words into cell
//        collectionView?.register(WordCell.self, forCellWithReuseIdentifier: cellId)
//        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
//        collectionView?.register(UICollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: footerId)
//    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection
//        section: Int) -> Int{
//        return 4
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:
//        IndexPath) -> UICollectionViewCell{
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        //        cell.backgroundColor = .green
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width:view.frame.width, height: 60)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
//        if kind == UICollectionView.elementKindSectionHeader{
//            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath)
//            header.backgroundColor = .red
//            return header
//        }
//        else{
//            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath)
//            footer.backgroundColor = .white
//            return footer
//        }
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 50)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
//        return CGSize(width: view.frame.width, height: 100)
//    }
//
//}
//
