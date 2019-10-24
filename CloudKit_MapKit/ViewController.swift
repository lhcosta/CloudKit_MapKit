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
     
}

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
