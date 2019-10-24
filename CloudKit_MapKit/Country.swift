//
//  Country.swift
//  CloudKit_MapKit
//
//  Created by Lucas Costa  on 23/10/19.
//  Copyright © 2019 LucasCosta. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CloudKit

struct Country {
    
    //MARK:- Properties
    private(set) var name : String!
    private(set) var flag : UIImage!
    private(set) var location : CLLocation!
    
    //MARK:- Initializer
    init(record : CKRecord) {
        
        guard let name = record.value(forKey: "name") as? String else {return}
        guard let location = record.value(forKey: "location") as? CLLocation else {return}
        guard let flag_asset = record.value(forKey: "flag") as? CKAsset else {return}
        
        guard let flag_url = flag_asset.fileURL else {return}
        
        do {
            
            let flag_data = try Data(contentsOf: flag_url)
            
            if let image = UIImage(data: flag_data)?.resizeImage(size: CGSize(width: 30, height: 30)) {
                self.flag = image
            }
            
        } catch let error as NSError {
            print("Error - \(error.userInfo)")
        }
        
        self.name = name
        self.location = location
    }

}
