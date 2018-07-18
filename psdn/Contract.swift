//
//  Contract.swift
//  psdn
//
//  Created by BlockChainDev on 06/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import Foundation

class Transaction: Encodable {
    var Inputs : [Input] = [Input]()
    var Outputs : [Output] = [Output]()
    var Attributes : [Attribute] = [Attribute]()
    var Version : UInt8 = 0
    var TransactionType : UInt8 = 128
    var Claims :[Input]?
    
    init(TransType: UInt8) {
        self.TransactionType = TransType
    }
    
}

struct Attribute :Codable {
    var Usage : UInt16
    var Data : Data
}
struct Input :Codable {
    var PrevHash : String?
    var PrevIndex : Int
    var Address : String?
    var External : Int
    var Index : Int
}
struct Output :Codable {
    var Address : String?
    var Value : Int64
    var AssetID : String?
}


//TODO: In Golang scriptbuilder, we want to check whether a string is an address, then serialise as a byte arr
struct ScriptBuilder {
    var Operation : String = ""
    var Scripthash : String = ""
    var Args : [Any] = [Any]()
    var Dictionary: [String: Any] {
        return ["Operation": Operation,"Args": Args,"Scripthash": Scripthash]
    }
}

//struct InvocTransfer :Codable {
//    var From :String
//    var To : String
//    var Amount : Int64
//    var Scripthash : String
//}


func dataWithHexString(hex: String) -> Data {
    var hex = hex
    var data = Data()
    while(hex.characters.count > 0) {
        let c: String = hex.substring(to: hex.index(hex.startIndex, offsetBy: 2))
        hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
        var ch: UInt32 = 0
        Scanner(string: c).scanHexInt32(&ch)
        var char = UInt8(ch)
        data.append(&char, count: 1)
    }
    return data
}


