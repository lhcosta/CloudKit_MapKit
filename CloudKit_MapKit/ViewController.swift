//
//  ViewController.swift
//  CloudKit_MapKit
//
//  Created by Lucas Costa  on 23/10/19.
//  Copyright © 2019 LucasCosta. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CloudKit

class ViewController: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet private weak var mapView : MKMapView!
    
    //MARK:- Properties
    private var locationConfiguration : LocationConfiguration!
    private var locationManager : CLLocationManager!
    private var databaseCloud : Database!
    private var countries : [Country]!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.countries = [Country]()
        self.mapView.delegate = self
        self.databaseCloud = Database(container: "iCloud.com.LucasCosta.CloudKit-MapKit", delegate: self)
        self.databaseCloud.fetchRecords()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.locationManager = CLLocationManager()
        self.locationConfiguration = LocationConfiguration(locationManager: self.locationManager)
    }
}

//MARK:- DatabaseDelegate
extension ViewController : DatabaseDelegate {
    
    func didFinishLoadingRecords(records: [CKRecord]) {
                
        records.forEach { [weak self] (record) in
            
            let country = Country(record: record)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = country.location.coordinate
            annotation.title = country.name
            
            self?.countries.append(country)
            self?.mapView.addAnnotation(annotation)
        }
    }
}

//MARK:- MKMapViewDelegate
extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation")
        
        annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
        annotationView?.canShowCallout = true
        guard let title = annotation.title as? String else {return nil}
                
        let country = self.countries.first {(country) -> Bool in
            return country.name == title
        }
        
        if let country = country {
            annotationView?.image = country.flag
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        guard let flag = view.image else {return}
        
        UIView.animate(withDuration: 2, delay: 0, options: .curveEaseOut, animations: { 
            guard let new_image = flag.resizeImage(size: CGSize(width: 60, height: 60)) else {return}
            view.image = new_image
        }, completion: nil)
    }
        
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let flag = view.image else {return}
               
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: { 
           guard let new_image = flag.resizeImage(size: CGSize(width: 30, height: 30)) else {return}
           view.image = new_image
        }, completion: nil)
    }
    
}


//MARK:- Extensions
extension UIImage {
    
    func resizeImage(size : CGSize) -> UIImage? {
                   
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height

        let ratio = min(widthRatio, heightRatio)

        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)

        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}
