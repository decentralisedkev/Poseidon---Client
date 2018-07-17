//
//  RealmModel_Transaction.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

/*
 The primary key is not needed in realm, however I will use it to stop duplicates in the transaction table
 
 For UTXOs:
    the primary key will take the address + txidnReceived
 For Transfers:
    Since transfers can be a received or a sent, we will check whether it is sent or recieved, and then append the appropriate txid onto the address
 */

import UIKit
import RealmSwift

class RealmModel_Transaction : Object {
    @objc dynamic var address : RealmModel_Account?
    @objc dynamic var txidNReceived : String?
    @objc dynamic var txidNSent : String?
    let blockReceived = RealmOptional<Int>()
    let blockSent = RealmOptional<Int>()
    let amount = RealmOptional<Int>()
    let sysFee = RealmOptional<Int>()
    @objc dynamic var from : String?
    @objc dynamic var to : String?
    @objc dynamic var asset : RealmModel_Asset?
    
    
    //PK
    @objc dynamic var addressTxidNReceivedSent : String?
    
    override static func primaryKey() -> String? {
        return "addressTxidNReceivedSent"
    }
    
}


