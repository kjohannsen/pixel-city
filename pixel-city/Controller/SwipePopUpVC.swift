//
//  SwipePopUpVC.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 7/15/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import UIKit

class SwipePopUpVC: UIViewController, UIGestureRecognizerDelegate {

    var passedImagesArray: [UIImage]!
    var selectedIndex: Int!
    
    @IBOutlet weak var swipeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addDoubleTap()
        swipeCollectionView.register(SwipePhotoCell.self, forCellWithReuseIdentifier: "SwipePhotoCell")
        //print(passedImagesArray)

    }
    
    func initPassedData(forImages images: [UIImage], andSelectedImage selectedIndex: Int) {
        self.passedImagesArray = images
        self.selectedIndex = selectedIndex
        
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dismissOnDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
    }
    
    @objc func dismissOnDoubleTap() {
        dismiss(animated: true, completion: nil)
    }
    

}

extension SwipePopUpVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return passedImagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipePhotoCell", for: indexPath) as? SwipePhotoCell else { return UICollectionViewCell()}
        let imageFromIndex = passedImagesArray[indexPath.row]
        let swipeImageView = UIImageView(image: imageFromIndex)
        swipeImageView.frame = cell.bounds
        swipeImageView.clipsToBounds = true
        swipeImageView.contentMode = .scaleAspectFit
        cell.addSubview(swipeImageView)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: swipeCollectionView.frame.width, height: swipeCollectionView.frame.height)
    }
    
    
}
