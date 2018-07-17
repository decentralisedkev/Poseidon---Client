//
//  Service_Account.swift
//  psdn
//
//  Created by BlockChainDev on 27/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift
struct Service_Account {
    
    var address : String?
    var external : Int?
    var index : Int?
    var net : String?
    var name : String?
    
    
    func save() {
        print("Here")

            var item = RealmModel_Account()
 
//            instance.printDbPath()
            item.address = self.address
            item.external.value = self.external
            item.index.value = self.index
            item.net = self.net
            item.name = self.name
            print("SAVEVE")
        let realm = try! Realm()
        try! realm.write {
            realm.add(item, update: true)
            
        }
//            instance.addObject(object: item)
   

    }
}

