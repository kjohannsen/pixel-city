//
//  PhotoCell.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 7/12/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import UIKit
import SkeletonView

class PhotoCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isSkeletonable = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
