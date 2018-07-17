//
//  Service_Asset.swift
//  psdn
//
//  Created by BlockChainDev on 21/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit


class Service_Asset : Decodable {
    @objc dynamic var name : String? // Antshares
    @objc dynamic var symbol : String? // NEO
    @objc dynamic var scriptHash : String?
    @objc dynamic var type : String? // Governing Token
    
    private enum CodingKeys: String, CodingKey {
        case name
        case symbol
        case scriptHash
        case type
    }
    
    func save() {
        let instance = RealmDBManager.sharedInstance
        var item = RealmModel_Asset()
        instance.printDbPath()
        item.name = name
        item.symbol = symbol
        item.scriptHash = scriptHash
        item.type = type
        
        instance.addObject(object: item)
        
    }

    
}
