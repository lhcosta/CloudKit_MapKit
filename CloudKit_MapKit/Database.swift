//
//  Database.swift
//  CloudKit_MapKit
//
//  Created by Lucas Costa  on 23/10/19.
//  Copyright © 2019 LucasCosta. All rights reserved.
//

import Foundation
import CloudKit

//MARK:- Delegate
protocol DatabaseDelegate : AnyObject {
    func didFinishLoadingRecords(records : [CKRecord])
}


struct Database {
    
    //MARK:- Properties
    private let database : CKDatabase
    private weak var delegate : DatabaseDelegate?
    
    //MARK:- Initializer
    init(container : String, delegate : DatabaseDelegate) {
        self.database = CKContainer(identifier: container).publicCloudDatabase
        self.delegate = delegate
    }
    
    //MARK:- Methods
    func fetchRecords() {
        
        var records = [CKRecord]()
        
        let query = CKQuery(recordType: "Country", predicate: NSPredicate(value: true))
        
        let sort = NSSortDescriptor(key: "name", ascending: true)

        query.sortDescriptors = [sort]
                
        let queryOperation = CKQueryOperation(query: query)
                    
        queryOperation.recordFetchedBlock = { (record) in
            records.append(record)
        }
        
        queryOperation.queryCompletionBlock = { (_, error) in
            if let error = error as? CKError {
                print("CKError - \(error) -\(error.userInfo)")
                return
            }
          
            self.delegate?.didFinishLoadingRecords(records: records)
        }
        
        self.database.add(queryOperation)
        
    }
}
