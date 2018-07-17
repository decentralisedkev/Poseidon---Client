//
//  Service.swift
//  psdn
//
//  Created by BlockChainDev on 20/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift
import NVActivityIndicatorView
class Service {
    
    static let sharedInstance = Service()
    
    private init() {}
    
    
    func synchroniseDatabaseWithBlockchain() {
        
        let instance = RealmDBManager.sharedInstance
        // Get all addresses from db
        let accounts = instance.fetchObjects(object: RealmModel_Account())
        
        // Get any new tokens/assets and add to db
        fetchAndSaveTokenInfo()
  
        for account in accounts {
            
            guard let address = account.address else {continue}
            print(address)

        
            
            
            // Get All UTXOs
            fetchOutputsAndSaveInDatabase(address: address) { (success) in
                if success {
                  

                    // update the spent utxos
                    self.checkForSpentUTXOs()
                  

                }
            }// TODO: Implement an afterBlock function, which will fetch outputs after a certain block
            
            // Get Any new token transactions
            fetchAndSaveTokenTransactionHistory(address: address)
        }
        
    }
    
    func fetchOutputsAndSaveInDatabase(address : String,completionHandler : @escaping (_ success : Bool)-> Void) {
        let baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/utxo?address="
        guard let url = URL(string: baseUrl + address) else {return}
        
            Alamofire.request(url).responseJSON { (response) in
                guard let data = response.data else {return}
                print(data)
                do {
                    let utxos = try JSONDecoder().decode([Service_UTXO].self, from: data)
                    // add into database
                    for utxo in utxos {
                        utxo.save()
                    }
                    completionHandler(true)

                } catch {
                    completionHandler(false)
                     print(error)
                }
                
            }
        
        
    }

    func fetchAndSaveTokenInfo() {
        
        let baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/tNames"
         guard let url = URL(string: baseUrl) else {return}
        
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            do {
                let tokens = try JSONDecoder().decode([Service_Asset].self, from: data)
                // add into database
                for token in tokens {
                    token.save()
                }
            } catch {
                print(error)
            }
            
        }
    }
    func fetchAndSaveTokenTransactionHistory(address : String) {
        let baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/transfer?address="
        guard let url = URL(string: baseUrl + address) else {return}
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            do {
                let transactions = try JSONDecoder().decode([Service_Transfer].self, from: data)
                for transaction in transactions {
                    transaction.Address = address
                    transaction.save()
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    func checkForSpentUTXOs() {
        let dbManager = RealmDBManager.sharedInstance
        
        let results = dbManager.fetchObjectsWithFilter(object: RealmModel_Transaction(), filter: returnPredicateForOnlyUTXOAssets())
        for result in results {
            guard let txid = result.txidNReceived  else {return}
            checkIfUTXOIsSpent(txidn: txid) { (input) in
                // TODO: We need to have the Inputs table, also put in the txid at which it was spent too
                do {
                    let realm = try! Realm()
                    realm.beginWrite()
                    result.txidNSent = input?.TXID
                    result.blockSent.value = input?.BlockNumber
                    try realm.commitWrite()
                } catch {
                    
                }

            }
            
         
            
        }
        
    }
    
   private func returnPredicateForOnlyUTXOAssets() -> NSPredicate {
        let utxoTypes = ["Governing Token", "Token", "Utility Token"]
        var predicates = [NSPredicate]()
        for utxoType in utxoTypes {
            let predicate = NSPredicate(format: "asset.type = %@", utxoType)
            predicates.append(predicate)
        }
        let predicateCompound = NSCompoundPredicate.init(type: .or, subpredicates: predicates)
        return predicateCompound
    }
    
    private func checkIfUTXOIsSpent(txidn : String,completionHandler : @escaping (_ data : Service_Input?)-> Void) {
        let baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/txo?txidn="
        guard let url = URL(string: baseUrl + txidn) else {completionHandler(nil); return}
        Alamofire.request(url).responseJSON { (response) in
            guard let data = response.data else {return}
            do {
                let utxos = try JSONDecoder().decode([Service_Input].self, from: data)
                if utxos.count == 1 {
                    completionHandler(utxos[0])
                }
            } catch {
                print(error)
            }
            
        }
    }
    
    func getAndParseInputs(completionHandler : @escaping (_ data : txo?)-> Void, txidn : String) {
        var baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/txo?txidn="
        let urlString = URL(string: baseUrl + txidn)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let decoder = JSONDecoder()
                        do {
                            let inputs = try decoder.decode([txo].self, from: usableData)
                            for input in inputs {
                                print(input.BlockNumber)
                                completionHandler(input)
                                return
                            }
                            completionHandler(nil)
                            print("Done")
                            
                        } catch {
                            completionHandler(nil)
                            print(error)
                        }
                        //JSONSerialization
                    }
                }
            }
            task.resume()
        }
    }
    
    
}
