//
//  SigningKeys.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import Foundation

struct SigningKeys {
    var external : Int
    var index : Int
    var toString : String {
        return String(describing:external) + "-" + String(describing:index)
    }
}
