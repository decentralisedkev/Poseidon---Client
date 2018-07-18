//
//  readme.md
//  psdn
//
//  Created by BlockChainDev on 07/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import Foundation

//HOw to do a contract transaction

var contract = Transaction(TransType: 128)
contract.Inputs.append(Input(PrevHash: "7ea261ac3bbb89eb11a105f955f996e5af56045326366243ed6e877e3057b5fc", vout: 0, Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", External: 0, Index: 1))
contract.Outputs.append(Output(Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", Value: 499, AssetID: "c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"))
//        let data = dataWithHexString(hex: "68656c6c6f2c20776f726c64")
//        contract.Attributes.append(Attribute(Usage: 0xff, Data: data))

let jsonData = try? contract.encode()
guard let res = HelloPrepareTransactionAndSign(Int(contract.TransactionType),jsonData, "online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {return}
let txid = String(describing: res.prefix(64))
print(res)
let txdata = String(describing: res.suffix((res.count)-64))
print(txid)

print(HelloSendTransaction("https://node1.neocompiler.io/ ", txdata))


// How to do a claim transaction64

var claim = Transaction(TransType: 2)
claim.Claims = [Input]()
claim.Claims?.append(Input(PrevHash: "f3f08d2ca6964bc96096dfd31334f7609564eca5b8559cff291ef625b863afea", vout: 0, Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", External: 0, Index: 1))
claim.Outputs.append(Output(Address: "ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo", Value:  Int64(HelloStringToFixed8("0.00055888"))!, AssetID: GAS))

let jsonData = try? claim.encode()
let jsonString = String(data: jsonData!, encoding: .utf8)!
print(jsonString)
guard let res = HelloPrepareTransactionAndSign(Int(claim.TransactionType),jsonData, "online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {return}
let txdata = String(describing: res.suffix((res.count)-64))
print(txdata)
print(HelloSendTransaction("https://node1.neocompiler.io/ ", txdata))


//How to do a invocation transaction

var invoke = Transaction(TransType: 209)
invoke.Version = 1

// These are the keys to be added
var keys = [String]()
keys.append("0-1")
keys.append("0-2")
keys.append("0-3")

let keysDict = ["Keys": keys]

//                let data = dataWithHexString(hex: "68656c6c6f2c20776f726c64")
//                invoke.Attributes.append(Attribute(Usage: 0xff, Data: data))

// Invocation Script
var sc = ScriptBuilder()
sc.Operation = "transfer"
sc.Scripthash = "40d404b53189ec11f4a63ccccfffe5f9407079a7"
sc.Args.append("ALxUuc4gSNaYdUUrPudem4DMkowz6x6Rwo")
sc.Args.append("APmxCmvGgb7bayoAApvFC6Aqa9pNqnUB5N")
sc.Args.append(Int(1))
let props = sc.Dictionary
//
do {
let transJsonData = try? invoke.encode()

var scriptJsonData = try JSONSerialization.data(withJSONObject: props,
options: .prettyPrinted)
var keysJsonData = try JSONSerialization.data(withJSONObject: keysDict,
options: .prettyPrinted)

//            print(String(data: jsonData, encoding: String.Encoding.utf8))
guard let res = HelloPrepareInvocationTransactionAndSign("transfer",transJsonData, scriptJsonData, keysJsonData,"online ramp onion faculty trap clerk near rabbit busy gravity prize employ") else {return}
let txid = String(describing: res.prefix(64))
print(txid)
let txdata = String(describing: res.suffix((res.count)-64))
print(txdata)
} catch let error {
print("error converting to json: \(error)")

}


