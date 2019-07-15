//
//  MapVC.swift
//  pixel-city
//
//  Created by Kyle Johannsen on 7/9/19.
//  Copyright © 2019 Kyle Johannsen. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import AlamofireImage
import SkeletonView

class MapVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Variables
    
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000 //meters
    var screenSize = UIScreen.main.bounds //this is a rectangle

    // MARK: Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    
    var spinner: UIActivityIndicatorView?
    var progressLabel: UILabel?
    
    var swipeDownMarkView: UIView?
    
    var flowLayout = UICollectionViewFlowLayout() //this is needed when creating a collection view programmatically
    var collectionView: UICollectionView?

    let numberOfCellsPerRow: CGFloat = 4
    
    var imageUrlArray = [String]()
    var imageArray = [UIImage]()
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        configureLocationServices()
        
        addDoubleTapToView()
        
        setUpPullUpView()
        addSwipeDownMarkerView()
        setUpFlowLayout()
        setUpCollectionView()
    }
    
    func addSwipeDownMarkerView() {
        swipeDownMarkView = UIView(frame: CGRect(x: (pullUpView.frame.width / 2 - 20), y: 7, width: 40, height: 6))
        swipeDownMarkView?.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        swipeDownMarkView?.layer.cornerRadius = 5.0
        pullUpView.addSubview(swipeDownMarkView!)
    }
    
    func setUpPullUpView() {
        pullUpView.layer.cornerRadius = 5.0
        pullUpView.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        pullUpView.layer.shadowOpacity = 1
        pullUpView.layer.shadowOffset = .zero
    }
    
    func addDoubleTapToView() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(dropPin(sender:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        cancelAllSessions()
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
//    func addSpinner() {
//        spinner = UIActivityIndicatorView()
//        spinner?.center = CGPoint(x: (screenSize.width / 2) - ((spinner?.frame.width)! / 2), y: (pullUpView.frame.height / 2) - ((spinner?.frame.height)! / 2))
//        spinner?.style = .whiteLarge
//        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        spinner?.startAnimating()
//        collectionView?.addSubview(spinner!)
//    }
    
//    func removeSpinner() {
//        if spinner != nil {
//            spinner?.removeFromSuperview()
//        }
//    }
    
//    func addProgressLabel() {
//        progressLabel = UILabel()
//        progressLabel?.frame = CGRect(x: (screenSize.width / 2) - 120, y: 175, width: 240, height: 40)
//        progressLabel?.font = UIFont(name: "Avenir Next", size: 18)
//        progressLabel?.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
//        progressLabel?.textAlignment = .center
//        collectionView?.addSubview(progressLabel!)
//    }
    
//    func removeProgressLabel() {
//        if progressLabel != nil {
//            progressLabel?.removeFromSuperview()
//        }
//    }

    // MARK: Actions
    
    @IBAction func centerUserLocationButtonWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
}

// MARK: Extensions

extension MapVC: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9771530032, green: 0.7062081099, blue: 0.1748393774, alpha: 1)
        pinAnnotation.animatesDrop = true
        return pinAnnotation
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func dropPin(sender: UITapGestureRecognizer) {
        //clear the view for new content
        removePin()
        collectionView?.hideSkeleton()
        collectionView?.stopSkeletonAnimation()
        cancelAllSessions()
        
        imageArray = []
        imageUrlArray = []
        collectionView?.reloadData()
        
        //build the new view
        animateViewUp()
        addSwipe()
        collectionView?.prepareSkeleton(completion: { (done) in
            self.collectionView?.showAnimatedSkeleton()
        })
        
        let touchPoint = sender.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        let annotation = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegion(center: touchCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
        getImageUrls(forAnnotation: annotation) { (finished) in
            if finished {
                self.getImages(handler: { (finished) in
                    if finished {
                        self.collectionView?.hideSkeleton()
                        self.collectionView?.stopSkeletonAnimation()
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
    }
    
    func removePin() {
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func getImageUrls(forAnnotation annotation: DroppablePin, handler: @escaping (_ status: Bool) -> ()) {
        Alamofire.request(yelpSearchUrl(forAnnotation: annotation, withSearchRadius: 1000, andResultsLimit: 40), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            guard let json = response.result.value as? Dictionary<String, AnyObject> else { return }
            let businessesDictArray = json["businesses"] as! [Dictionary<String, AnyObject>]
            for business in businessesDictArray {
                let imageUrl = "\(business["image_url"]!)"
                self.imageUrlArray.append(imageUrl)
            }
            handler(true)
        }
    }
    
    func getImages(handler: @escaping (_ status: Bool) -> ()) {
        for url in imageUrlArray {
            Alamofire.request(url).responseImage { (response) in
                guard let image = response.result.value else { return }
                self.imageArray.append(image)
                self.progressLabel?.text = "\(self.imageArray.count)/40 PHOTOS LOADED"
                
                if self.imageArray.count == self.imageUrlArray.count {
                    handler(true)
                }
            }
        }
    }
    
    func cancelAllSessions() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
            sessionDataTask.forEach({ $0.cancel() })
            downloadData.forEach({ $0.cancel() })
        }
    }
}

extension MapVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
}

extension MapVC: SkeletonCollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "photoCell"
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? PhotoCell else { return UICollectionViewCell() }
        let imageFromIndex = imageArray[indexPath.row]
        let cellImageView = UIImageView(image: imageFromIndex)
        cellImageView.frame = cell.bounds
        cellImageView.clipsToBounds = true
        cellImageView.contentMode = .scaleAspectFill
        cellImageView.isSkeletonable = true
        cell.addSubview(cellImageView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let popUpVC = storyboard?.instantiateViewController(withIdentifier: "PopUpVC") as? PopUpVC else { return }
        popUpVC.initPassedData(forImage: imageArray[indexPath.row])
        present(popUpVC, animated: true, completion: nil)
    }
    
    func setUpFlowLayout() {
        flowLayout.minimumInteritemSpacing = 3.0
        flowLayout.minimumLineSpacing = 3.0
        let horizontalSpacing = flowLayout.scrollDirection == .vertical ? flowLayout.minimumInteritemSpacing : flowLayout.minimumLineSpacing
        let cellWidth = (view.frame.width - max(0, numberOfCellsPerRow - 1)*horizontalSpacing)/numberOfCellsPerRow
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    func setUpCollectionView() {
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 20, width: view.frame.width, height: view.frame.height - 20), collectionViewLayout: flowLayout) //adds a top inset for swiping down
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "photoCell")
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        collectionView?.isSkeletonable = true
        pullUpView.addSubview(collectionView!)
    }
}
