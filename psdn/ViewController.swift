//
//  ViewController.swift
//  psdn
//
//  Created by BlockChainDev on 05/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import Hello


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        var keyData = HelloPrinter("lol")
//        print(keyData)
//            print(HelloNewAccount())
//        var address = HelloGenerateAddress("online ramp onion faculty trap clerk near rabbit busy gravity prize employ", 0, 0)
//        print(address)
//
        
        // Claim Transaction
        var keys = [String]()
        keys.append(SigningKeys(external: 0, index: 1).toString)
        keys.append(SigningKeys(external: 0, index: 2).toString)
        keys.append(SigningKeys(external: 0, index: 3).toString)
        
        let keysDict = ["Keys": keys]
        
        var claim = Transaction(TransType: 2)
        claim.Claims = [Input]()
        claim.Claims?.append(Input(PrevHash: "f3f08d2ca6964bc96096dfd31334f7609564eca5b8559cff291ef625b863afea", PrevIndex: 0, Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", External: 0, Index: 1))
        claim.Outputs.append(Output(Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", Value:  Int64(HelloStringToFixed8("0.00055888"))!, AssetID: GAS))
        do {
            var keysJsonData = try JSONSerialization.data(withJSONObject: keysDict,
                                                          options: .prettyPrinted)
            let jsonData = try? claim.encode()
            let jsonString = String(data: jsonData!, encoding: .utf8)!
            print(jsonString)
            guard let res = HelloPrepareTransactionAndSign(Int(claim.TransactionType),jsonData, keysJsonData, "online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {return}
            let txdata = String(describing: res.suffix((res.count)-64))
            print(txdata)
            print(HelloSendTransaction("https://node1.neocompiler.io/ ", txdata))
        }catch {
            print(error)
        }



       // So we have added this keys construct and will need to use it with Claims as, the claims do not have inputs either.
    }
    



}


// In order to sign transactions, the user needs to store the private key, the derivation path and the address
// So the generateFunc should return private key, address and

// We will deal with all of the data in golang, it will return just the string representation

//




extension String {
    func base64Encoded() -> String? {
        return data(using: .utf8)?.base64EncodedString()
    }
    
    func base64Decoded() -> String? {
        guard let data = Data(base64Encoded: self) else { return nil }
        return String(data: data, encoding: .utf8)
    }
}


func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

