//
//  TestViewController.swift
//  psdn
//
//  Created by BlockChainDev on 14/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift
import Hello

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let instance = Service.sharedInstance
        RealmDBManager.sharedInstance.printDbPath()
        instance.synchroniseDatabaseWithBlockchain()
//        instance.checkIfUTXOIsSpent(txidn: "0x2f101641ad2e9f8121ce9321f89b05837c0d7b4d6d611c738b5092ad053288d2_0") { (txo) in
//            print(txo,"Resust complete")
//        }
//        instance.fetchOutputs(address: "AMDJBQVm8NWKxs4n2bgncayRV9kpbbg26a")
//        instance.fetchAndSaveTokenInfo()
//        instance.fetchAndSaveTokenTransactionHistory(address: "AMDJBQVm8NWKxs4n2bgncayRV9kpbbg26a")
//        let instance = RealmDBManager.sharedInstance
//        instance.printDbPath()
//        var item = RealmModel_Account()
//        item.address = "AMDJBQVm8NWKxs4n2bgncayRV9kpbbg26a"
//        item.external.value = 0
//        item.index.value = 1
//
//        instance.addObject(object: item)
//        var contract = Transaction(TransType: 128)
//
//        contract.Inputs.append(Input(PrevHash: "b4a11cfbc1c6dd507173bae2ab88ba5503175c6ba06f804af1091f30d8b1eebc", vout: 0, Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", External: 0, Index: 1))
//        contract.Outputs.append(Output(Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", Value: 2000, AssetID: GAS))
//        guard var res = WalletManager.sharedInstance.PrepareContractTransactionAndSign(trans: contract, keys: [], mnemonic: "online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {print("Bad transaction");return}
//        print(res.txid)
//        WalletManager.sharedInstance.SendTransaction(rpcUrl: "http://188.68.34.29:10004", txdata: res.txdata)
        
//        var invoke = Transaction(TransType: 209)
//        invoke.Version = 1
//
//        var keys = [SigningKeys]()
//        keys.append(SigningKeys(external: 0, index: 1))
//        let data = dataWithHexString(hex: "68656c6c6f2c20776f726c64")
//        invoke.Attributes.append(Attribute(Usage: 0xff, Data: data))
//
//        // Invocation Script
//        var sc = ScriptBuilder()
//        sc.Operation = "transfer"
//        sc.Scripthash = "9aff1e08aea2048a26a3d2ddbb3df495b932b1e7"
//        sc.Args.append("ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo")
//        sc.Args.append("ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo")
//        sc.Args.append(Int(100))
//
//        guard let res = WalletManager.sharedInstance.PrepareInvocationTransactionAndSign(trans: invoke, script: sc, keys: keys, mnemonic: "online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {return}
//        print(res)
//        let sent = WalletManager.sharedInstance.SendTransaction(rpcUrl: "https://seed1.neo.org:20331", txdata: res.txdata)
//        print(sent)
        
        
        
        //        let data = dataWithHexString(hex: "68656c6c6f2c20776f726c64")
        //        contract.Attributes.append(Attribute(Usage: 0xff, Data: data))
        
//        let db = RealmDBManager.sharedInstance
//        db.printDbPath()
//        var obj = RealmModel_Asset()
//        obj.name = "Test Insert Name"
//        obj.scriptHash = "Test Insert ScriptHash"
//        obj.symbol = "Test Insert Symbol"
//        obj.fiatPrice = RealmModel_FiatPrice(value: ["symbolCurrency":"CurrencyTestSymbol"])
//        db.addObject(object: obj)

        //        do {
//            try FileManager.default.removeItem(at:Realm.Configuration.defaultConfiguration.fileURL!)
//        } catch {
//            print(error)
//        }
        
//        DispatchQueue.global().async {
//            self.getAndInsertOutputs(address : "AMDJBQVm8NWKxs4n2bgncayRV9kpbbg26a")
//        }
//        getTokenInfo()
//        getAndInsertTokenInfo(address: "AMDJBQVm8NWKxs4n2bgncayRV9kpbbg26a")
//
//        print(HelloNewAccount())
    }
    
    func getAndInsertOutputs(address : String) {
        var baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/utxo?address="
        let urlString = URL(string: baseUrl + address)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let decoder = JSONDecoder()
                        do {
                           
                            let utxos = try decoder.decode([UTXORealm].self, from: usableData)
                        
                            for utxo in utxos {
                                utxo.address_txid_n = utxo.Address + "_" + utxo.TxID_N
                                self.getAndParseInputs(completionHandler: { (txo) in
                                    if let txo = txo {
                                        utxo.spent = true
                                        utxo.End = txo.BlockNumber
                                       DBManager.sharedInstance.addData(object: utxo)
                                    } else {
                                        DBManager.sharedInstance.addData(object: utxo)
                                    }
                                }, txidn: utxo.TxID_N)
                            }
                            print("Done")
                            
                        } catch {
                            print(error)
                        }
                        //JSONSerialization
                    }
                }
            }
            task.resume()
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
    
    func getTokenInfo() {
        
        var baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/tNames"
        let urlString = URL(string: baseUrl)
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let usableData = data {
                        let decoder = JSONDecoder()
                        do {
                            
                            let utxos = try decoder.decode([UTXOAsset].self, from: usableData)
                            for utxo in utxos {
                                DBManager.sharedInstance.addData(object: utxo)
                            }
                            var neo = UTXOAsset()
                            neo.AssetID = "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"
                            neo.Name = "NEO"
                            neo.Symbol = "NEO"
                            DBManager.sharedInstance.addData(object: neo)
                            var gas = UTXOAsset()
                            gas.AssetID = "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7"
                            gas.Name = "GAS"
                            gas.Symbol = "GAS"
                            DBManager.sharedInstance.addData(object: gas)
                            print("Done")
                            print(Realm.Configuration.defaultConfiguration.fileURL!)
                        } catch {
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

func getAndInsertTokenInfo(address : String) {
    var baseUrl = "https://yrslot6bsd.execute-api.us-east-1.amazonaws.com/dev/transfer?address="
    let urlString = URL(string: baseUrl + address)
    if let url = urlString {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
            } else {
                if let usableData = data {
                    let decoder = JSONDecoder()
                    do {
                        DBManager.sharedInstance.printDbPath()
                        let transfers = try decoder.decode([TransferAsset].self, from: usableData)
                        for transfer in transfers {
                            transfer.Address = address
                            print(transfer.ScriptHash)
                            transfer.address_txid = transfer.Address + "_" + transfer.TxID
                            DBManager.sharedInstance.addData(object: transfer)
                        }

                        print("Done")
                      
                    } catch {
                        print(error)
                    }
                    //JSONSerialization
                }
            }
        }
        task.resume()
    }
}

struct txo: Decodable {
    var TxID_N : String
    var BlockNumber : Int
}


