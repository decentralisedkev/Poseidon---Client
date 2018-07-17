//
//  RealmModel_FiatPrice.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

/*
 When the user selects USD as their default currency, we will update the FIatPrice Object in the Assets File To match the user set currency
 
 E.g.
  symbolCurrency = "NEO_USD"
  fiatPrice = 20.0
  This means that one neo equals $20.0 
 */

import UIKit
import RealmSwift

class RealmModel_FiatPrice : Object {
 
    @objc dynamic var symbolCurrency : String? // E.g. NEO_EUR or GAS_USD
    @objc dynamic var fiatPrice : Float = 0.0 // would ideally like to set this
    
    override static func primaryKey() -> String? {
        return "symbolCurrency"
    }
    
}

