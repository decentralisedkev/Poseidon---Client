//
//  HomeDataSource.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift

class HomeDataSource : baseDataSource {
    var data : [Results<RealmModel_Transaction>] = [Results<RealmModel_Transaction>]()
    
    var address : String?
    
    override func numberOfItems(_ section: Int) -> Int {
        return data.count
    }
    override func cellClasses() -> [baseViewCell.Type] {
        return [HomeCellView.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return data[indexPath.item]
    }
    
    init(_ address : String) {
        super.init()
        self.address = address
        
            self.requestData()
        
     
    }
    func requestData() {
        guard let address = address else {return}
        let dbInstance = RealmDBManager.sharedInstance
        let assets = dbInstance.fetchObjects(object: RealmModel_Asset())
        
        for asset in assets {
            guard let scripthash = asset.scriptHash else {continue}
            let predicate = NSPredicate(format: "asset.scriptHash =  %@ AND address.address = %@", scripthash, address)
            let results = dbInstance.fetchObjectsWithFilter(object: RealmModel_Transaction(), filter: predicate)
            if results.count > 0 {
                data.append(results)
            }
            
        }
        
    }
}
