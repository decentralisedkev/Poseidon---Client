//
//  RealmModel_Assets.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift

class RealmModel_Asset : Object {
    @objc dynamic var name : String? // Antshares
    @objc dynamic var symbol : String? // NEO
    @objc dynamic var scriptHash : String?
    @objc dynamic var type : String? // Governing Token
    @objc dynamic var fiatPrice : RealmModel_FiatPrice? // default value of zero on this

    override static func primaryKey() -> String? {
        return "scriptHash"
    }
    
}

