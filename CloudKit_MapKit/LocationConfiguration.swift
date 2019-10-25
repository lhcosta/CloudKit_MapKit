//
//  LocationConfiguration.swift
//
//  Created by Lucas Costa  on 22/10/19.
//  Copyright © 2019 LucasCosta. All rights reserved.

import Foundation
import MapKit
import CoreLocation

class LocationConfiguration : NSObject {
    
    private let locationManager : CLLocationManager
    
    init(locationManager : CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func checkLocationServices()  {
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.checkLocationAuthorization()
        }
        
    }
    
    private func checkLocationAuthorization() {
        
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                self.locationManager.startUpdatingLocation()
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            default:
            break
        }
        
    }    
}
