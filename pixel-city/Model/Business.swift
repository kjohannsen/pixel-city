//
//  Business.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 8/12/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import Foundation
import UIKit

struct Business {
    var name: String
    var imageUrl: String
    var image: UIImage?
    
    init(name: String, imageUrl: String, image: UIImage?) {
        self.name = name
        self.imageUrl = imageUrl
        self.image = image
    }
    
}