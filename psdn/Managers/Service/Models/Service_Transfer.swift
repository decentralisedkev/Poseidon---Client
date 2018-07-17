//
//  Service_Transfer.swift
//  psdn
//
//  Created by BlockChainDev on 21/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

/*
 "blockNumber": 2005114,
 "TXID": "0xe31b9a50169944fcaf74c963e592694faea84bfd972305667da27a9ded4cb163",
 "ScriptHash": "0xceab719b8baa2310f232ee0d277c061704541cfb",
 "Type": "sent",
 "Value": "-150000000",
 "To": "AJzoeKrj7RHMwSrPQDPdv61ciVEYpmhkjk"
 
 */
class Service_Transfer : Decodable {
    var BlockNumber = 0
    var TXID: String?
    var ScriptHash : String = ""
    var Address : String = ""
    var Value : String = ""
    var To : String? =  nil
    var From : String? = nil
    var type : String? =  nil
 
    
    
    private enum CodingKeys: String, CodingKey {
    
       case BlockNumber = "blockNumber"
        case ScriptHash
        case Value
        case type = "Type"
        case To
        case From
        case TXID
    }
    
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
         self.TXID = try values.decode(String.self, forKey: .TXID)
        self.BlockNumber = try values.decode(Int.self, forKey: .BlockNumber)
        self.ScriptHash = try values.decode(String.self, forKey: .ScriptHash)
        self.Value = try values.decode(String.self, forKey: .Value)
        self.type = try values.decode(String.self, forKey: .type)

        
        if values.contains(.To) {
            self.To = try values.decodeIfPresent(String.self, forKey: .To)
        }
        
        if values.contains(.From) {
            self.From = try values.decodeIfPresent(String.self, forKey: .From)
        }
    }
    

    func save() {
        let instance = RealmDBManager.sharedInstance
        var item = RealmModel_Transaction()
        
        // get address that it links to
        guard let account = instance.fetchObjectWithPrimaryKey(object: RealmModel_Account(), key: self.Address)  else {return}
        item.address = account
        guard let asset = instance.fetchObjectWithPrimaryKey(object: RealmModel_Asset(), key: self.ScriptHash) else {return}
        item.asset = asset
        item.amount.value = Int(self.Value)
        
        guard let txid = self.TXID else {return}
        
        if type == "sent" {
            item.from = self.Address
            item.txidNSent = txid
            item.to = self.To
            item.blockSent.value = Int(self.BlockNumber)
            
        } else if type == "received" { 
            
            item.from = self.From
            item.to = self.Address
            item.txidNReceived = txid
            item.blockReceived.value = Int(self.BlockNumber)
            
        } else if type == "deploy" {
            type = "Airdrop"
            item.from = "Contract"
            item.to = self.Address
            item.txidNReceived = txid
            item.blockReceived.value = Int(self.BlockNumber)
            
        }
        
        item.addressTxidNReceivedSent = self.Address+"_"+txid
    
        instance.printDbPath()
        
        instance.addObject(object: item)
        
    }
    
}
