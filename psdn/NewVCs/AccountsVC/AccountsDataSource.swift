//
//  AccountsDataSource.swift
//  psdn
//
//  Created by BlockChainDev on 27/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift

class AccountsDataSource : baseDataSource {
    var data = [RealmModel_Account]()
    
    override func numberOfItems(_ section: Int) -> Int {
        return data.count
    }
    override func cellClasses() -> [baseViewCell.Type] {
        return [AccountsCellView.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return data[indexPath.item]
    }
    
    override init() {
        super.init()
        requestData()
    }
    func requestData() {
        
        let dbInstance = RealmDBManager.sharedInstance
        let accounts = dbInstance.fetchObjects(object: RealmModel_Account())
        for account in accounts {
            print("Appenfing")
            data.append(account)
        }
        print(data.count)
        
    }
}
