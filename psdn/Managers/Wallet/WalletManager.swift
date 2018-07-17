//
//  WalletManager.swift
//  psdn
//
//  Created by BlockChainDev on 19/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Hello
import KeychainSwift

class WalletManager {
   
    static let sharedInstance = WalletManager()
    private init() {}
     let keychain = KeychainSwift()
    var secureEnclave = SecEnclave()
    
    
    // true means new wallet was created, encrypted and stored in chain
    func NewWallet() -> Bool{
        // new ECKeyPair to ecnrypt data
        secureEnclave.newECKeyPair()
        
        guard let mnemonic = HelloNewAccount() else {
            // TODO: Warn user that mnemonic was not created, due to error
            return false
        }
        

        AddNewAddress(mnemonic: mnemonic, Change: 0, Index: GetCurrentPathIndex(), name: "Default", network: "TestNet")

        print("Generated seed:", mnemonic)
        
        guard let encryptedMnemonic = secureEnclave.encrypt(message: mnemonic) else {
            // TODO: Error: Problem encrypting mnemonic
            return false
        }
        
        let keychain = KeychainSwift()
        keychain.set(encryptedMnemonic, forKey: "mnemonicKey")
        
        return true
    }
    
    func GetCurrentPathIndex() -> Int {
        
        let key = "indexPath"
        
        let index = UserDefaults.standard.integer(forKey: key)
        UserDefaults.standard.set(index+1, forKey: key)
        return index
    }
    
    func AddNewAddress(mnemonic : String, Change : Int, Index : Int, name : String, network : String ) -> String?{
        guard let address =  HelloGenerateAddress(mnemonic, Change, Index) else {return nil}
        print("Before save")
        var account = Service_Account(address: address, external: Change, index: Index, net: network, name: name)
        account.save()
        print("After save")
        return address
    }
    
    // TODO:This uses two completionhandlers, is this a good practice?
    func GetMnemonic(returnMnemonic: @escaping (_ seed:String?) -> ()){
        
        guard let encryptedMnemonicFromStorage = keychain.get("mnemonicKey") else{
                returnMnemonic(nil)
                return
        }
        secureEnclave.decrypt(digest: encryptedMnemonicFromStorage) { (seed) in
            returnMnemonic(seed)
        }
        returnMnemonic(nil)
    }

    func SendTransaction(rpcUrl : String, txdata : String, completionHandler : (_ success:Bool)-> ()){
        completionHandler(HelloSendTransaction(rpcUrl, txdata))
    }
    
    private func PrepareTransactionAndSign(trans : Transaction, script : ScriptBuilder? ,keys: [SigningKeys],mnemonic : String) -> SignedTransactionResponse?{
        
         var transactionType = Int(trans.TransactionType)
        
        guard var keysAsJson = KeysArrayToData(keys) else {return nil}
        
        guard var transactionAsJson = TransactionToData(trans) else {return nil}
        
        var transactionResponse : String?
        
        if let script = script {
            
            guard let scriptAsJson = scriptToData(script) else {return nil}
            
            transactionResponse=HelloPrepareInvocationTransactionAndSign(script.Operation, transactionAsJson, scriptAsJson, keysAsJson, mnemonic)
        } else {
            transactionResponse=HelloPrepareTransactionAndSign(transactionType,transactionAsJson, keysAsJson, mnemonic)
        }
        
        guard let txdata_txid = transactionResponse else {return nil}
        print(txdata_txid)
        let txid = String(describing: txdata_txid.prefix(64))
        let txdata = String(describing: txdata_txid.suffix((txdata_txid.count)-64))
        
        return SignedTransactionResponse(txid: txid, txdata: txdata)
    }
    func PrepareContractTransactionAndSign(trans : Transaction, keys: [SigningKeys],mnemonic : String) -> SignedTransactionResponse?{
        
        return PrepareTransactionAndSign(trans: trans, script: nil, keys : keys, mnemonic: mnemonic)
    }
    

    func PrepareClaimTransactionAndSign(trans : Transaction, keys: [SigningKeys],mnemonic : String) -> SignedTransactionResponse?{
        
        return PrepareTransactionAndSign(trans: trans, script: nil, keys : keys, mnemonic: mnemonic)
    }
    
    func PrepareInvocationTransactionAndSign(trans : Transaction, script : ScriptBuilder ,keys: [SigningKeys],mnemonic : String) -> SignedTransactionResponse?{
        
        return PrepareTransactionAndSign(trans: trans, script: script, keys: keys, mnemonic: mnemonic)
        
    }
    private func KeysArrayToData(_ keys : [SigningKeys]) -> Data?{
        
        var keysAsString = [String]()
        for i in 0 ..< keys.count {
            keysAsString.append(keys[i].toString)
        }
        
        var keysAsDict = ["Keys": keysAsString]
        var keysAsJson : Data?
        do {
            keysAsJson = try JSONSerialization.data(withJSONObject: keysAsDict,options: .prettyPrinted)
            return keysAsJson
        } catch {
            return keysAsJson
        }
        
    }
    
    private func TransactionToData(_ trans : Transaction) -> Data? {
        
        var transactionAsJson : Data?
        
        do {
            transactionAsJson = try? trans.encode()
            return transactionAsJson
        } catch {
            return transactionAsJson
        }
        
    }
    
    private func scriptToData(_ script : ScriptBuilder) -> Data? {
        let props = script.Dictionary
        do {
            var scriptJsonData = try JSONSerialization.data(withJSONObject: props,
                                                            options: .prettyPrinted)
            return scriptJsonData
        }catch {
            return nil
        }
    }

}
