////
////  RealmDBManager.swft.swift
////  psdn
////
////  Created by BlockChainDev on 14/06/2018.
////  Copyright © 2018 kwopltd. All rights reserved.
////
//
//import UIKit
//import RealmSwift
//
//class DBManager {
//    private var database:Realm
//    static let sharedInstance = DBManager()
//    private init() {
//        database = try! Realm()
//    }
//    
//    func printDbPath() {
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
//    }
//    func getUTXODataFromDB() ->   Results<UTXORealm> {
//        let results: Results<UTXORealm> =   database.objects(UTXORealm.self)
//        return results
//    }
//    func getUTXODataFromDB(assetID : String) ->   Results<UTXORealm> {
//        let predicate = NSPredicate(format: "Asset = %@", assetID)
//        let results = database.objects(UTXORealm.self).filter(predicate)
//        return results
//    }
//    func getTransferDataFromDB() ->   Results<TransferAsset> {
//        let results: Results<TransferAsset> =   database.objects(TransferAsset.self)
//        return results
//    }
//    func getTransferDataFromDB(assetID : String) ->   Results<TransferAsset> {
//        let predicate = NSPredicate(format: "ScriptHash = %@", assetID)
//        let results: Results<TransferAsset> =   database.objects(TransferAsset.self).filter(predicate)
//        return results
//    }
//    func getUTXOAsset(currentAsset : String) -> UTXOAsset? {
//        print("Curr:", currentAsset)
//         let obj = database.object(ofType: UTXOAsset.self, forPrimaryKey: currentAsset)
//        return obj
//        
//    }
//    func getUTXOAsset(Symbol : String) -> UTXOAsset? {
//        let predicate = NSPredicate(format: "Symbol = %@", Symbol)
//        let obj = database.objects(UTXOAsset.self).filter(predicate).first
//        print("Object fetched", obj)
//        return obj
//        
//    }
//    func getCoinSummary() -> Results<CoinRealm> {
//        let results : Results<CoinRealm>  = database.objects(CoinRealm.self)
//        return results
//        
//    }
//    
//    func addData<T: Object>(object: T)   {
//        
//        database = try! Realm()
//            try! self.database.write {
//                self.database.add(object, update: true)
//                print("Added new object")
//            }
//
//    }
//    
//    func transferObjectExist (id: String) -> Bool {
//        return database.object(ofType: TransferAsset.self, forPrimaryKey: id) != nil
//    }
//    func deleteAllFromDatabase()  {
//        try! database.write {
//            database.deleteAll()
//        }
//    }
//    func deleteFromDb(object: UTXORealm)   {
//        try! database.write {
//            database.delete(object)
//        }
//    }
//}
//
//class UTXORealm: Object, Decodable {
//    @objc dynamic var Address = ""
//    @objc dynamic var TxID_N = ""
//    @objc dynamic var address_txid_n = "" // realm does not support compund keys, so the workaround is to use this
//    @objc dynamic var spent: Bool = false
//    @objc dynamic var Start = 0
//    @objc dynamic var End = 0
//    @objc dynamic var Value : String = ""
//    @objc dynamic var Asset : String = ""
//    
//    private enum CodingKeys: String, CodingKey {
//        case Address
//        case TxID_N
//        case Start
//        case Value
//        case Asset
//    }
//    override static func primaryKey() -> String? {
//        return "address_txid_n"
//    }
//}
//class UTXOAsset: Object, Decodable {
//    @objc dynamic var AssetID = ""
//    @objc dynamic var Name = ""
//    @objc dynamic var Symbol = ""
//     @objc dynamic var Net = "Main"
//    
//    private enum CodingKeys: String, CodingKey {
//        case AssetID
//        case Name
//        case Symbol
//    }
//    
//    override static func primaryKey() -> String? {
//        return "AssetID"
//    }
//}
//
//class CoinRealm : Object {
//    @objc dynamic var name : String?
//    @objc dynamic var coinPrice : Float = 0.0
//    @objc dynamic var fiatPrice : Float = 0.0 // coin to fiat equivalent
//    @objc dynamic var fiatPerPrice : Float = 0.0 // per coin equivalent
//    
//    override static func primaryKey() -> String? {
//        return "name"
//    }
//    
//}
//
//class TransferAsset : Object, Decodable {
//    //
//    @objc dynamic var Address : String = ""
//    @objc dynamic var TxID : String = ""
//    @objc dynamic var address_txid = ""
//    @objc dynamic var type : String?
//    @objc dynamic var Value : String?
//    @objc dynamic var From : String?
//    @objc dynamic var To : String?
//    @objc dynamic var ScriptHash : String?
//    @objc dynamic var blockNumber : Int = 0
//    
//    private enum CodingKeys: String, CodingKey {
//
//        case TxID = "TXID"
//        case type = "Type"
//        case Value
//        case From
//        case To
//        case blockNumber
//        case ScriptHash
//    }
//    
//    
//    override static func primaryKey() -> String? {
//        return "address_txid"
//    }
//    
//}
//
//class AddressRealm : Object, Decodable {
//   
//    @objc dynamic var Address : String = ""
//    @objc dynamic var External : Int = 0
//    @objc dynamic var Index : Int = 0
//    
//    private enum CodingKeys: String, CodingKey {
//        case Address
//        case External
//        case Index
//    }
//    
//    override static func primaryKey() -> String? {
//        return "Address"
//    }
//    
//}
