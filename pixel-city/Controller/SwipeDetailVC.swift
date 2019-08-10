//
//  SwipeDetailVC.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 8/9/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import UIKit

class SwipeDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var swipeCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    var selectedIndex = IndexPath()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        swipeCollectionView.delegate = self
        swipeCollectionView.dataSource = self
        
        swipeCollectionView.scrollToItem(at: selectedIndex, at: .centeredHorizontally, animated: true)
        
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SwipePhotoCell", for: indexPath) as? SwipePhotoCell else { return UICollectionViewCell() }
        cell.imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellSize = CGSize(width: swipeCollectionView.frame.width, height: swipeCollectionView.frame.height)
        return cellSize
    }
    
}
