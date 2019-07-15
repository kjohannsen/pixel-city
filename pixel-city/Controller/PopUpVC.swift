//
//  PopUpVC.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 7/14/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import UIKit

class PopUpVC: UIViewController, UIGestureRecognizerDelegate {

    var passedImage: UIImage!
    
    @IBOutlet weak var popUpImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpImageView.image = passedImage
        addDoubleTap()
    }
    
    func initPassedData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    func addDoubleTap() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(screenWasDoubleTapped))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        view.addGestureRecognizer(doubleTap)
        
    }
    
    @objc func screenWasDoubleTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
