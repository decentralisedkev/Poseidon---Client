//
//  RealmModel_Account.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

import RealmSwift

class RealmModel_Account : Object {
    
    @objc dynamic var address : String?
    let external = RealmOptional<Int>()
    let index = RealmOptional<Int>()
    @objc dynamic var net : String?
    @objc dynamic var name : String?
    
    
    override static func primaryKey() -> String? {
        return "address"
    }
}

