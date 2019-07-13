//
//  Constants.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 7/13/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import Foundation

let API_KEY = "isJVIFgDdZzRBoSXrhV4RLkyGCIqyJuned-DIxpd_H1x14NTMcKu2WJuSWeO0tWad6HWJFCLMBmpeBWFUKOaQO-lyW6dReu9owYlPzAWp9wzs9GQBlYpcm1mAbgpXXYx"

let BEARER_HEADER = [
    "Authorization":"Bearer \(API_KEY)"
]

// let clientID = "Q5I52p_h4KtauCVR_vfSeg"

func yelpSearchUrl(forAnnotation annotation: DroppablePin, withSearchRadius radius: Int, andResultsLimit limit: Int) -> String {
    return "https://api.yelp.com/v3/businesses/search?latitude=\(annotation.coordinate.latitude)&longitude=\(annotation.coordinate.longitude)&radius=\(radius)&limit=\(limit)"
}
