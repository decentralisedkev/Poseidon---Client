//
//  RealmStats.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit
import RealmSwift
import Hello

func sumNEP5Transactions(results : Results<RealmModel_Transaction>) -> Double{
    
    
    var total = 0
    for transaction in results {
        guard let amount = transaction.amount.value else {continue}
        total += amount
    }
    return Double(total) / Double(100000000)
    
    
}

func sumUTXOBasedTransaction(results : Results<RealmModel_Transaction>) -> Double {
    var total = 0
    for transaction in results {
        if transaction.txidNSent == nil {
            guard let amount = transaction.amount.value else {continue}
            total += amount
        }
    }
    return Double(total) / Double(100000000)
}

func nep5ToTransCellItem(results : Results<RealmModel_Transaction>) -> [transCellItem] {
    
    var data = [transCellItem]()
    
    let addr = results[0].address?.address
    guard let symbol = results[0].asset?.symbol else {return data}

    
    for result in results {
        guard let amountFixed8 = result.amount.value else {return data}
        let amount = Double(amountFixed8) / Double(100000000)
        print("THis is amount", amount)
        if addr == result.to {
            
            guard let blockRec = result.blockReceived.value else {continue}
             guard let txid = result.txidNReceived else {continue}
    
            data.append(transCellItem(type: "Received", amount: String(describing: amount) + " " + symbol, blockNumber: String(describing: blockRec), txid: txid))
        } else {
            guard let blockSent = result.blockSent.value else {continue}
           
              guard let txid = result.txidNSent else {continue}
            data.append(transCellItem(type: "Sent", amount: String(describing: amount) + " " + symbol, blockNumber: String(describing: blockSent), txid: txid))
        }
    }
    print(data)
    return data
}
func utxoToTransCellItem(results : Results<RealmModel_Transaction>) -> [transCellItem] {
    
    var data = [transCellItem]()
    
    var fromArr = [RealmModel_Transaction]()
    var toArr = [RealmModel_Transaction]()
    
    // first split up transaction by received and sent
    
    // then group transactions with the same txid together in each array and add up their amounts
    
    var txidsReceived = [String]()
    var txidsSent = [String]()
    
    for result in results {
        guard let txidReceived = result.txidNReceived as? String else {continue}
        txidsReceived.append(txidReceived)
        fromArr.append(result)
        if result.txidNSent != nil {
            guard let txidSent = result.txidNSent as? String else {continue}
            txidsSent.append(txidSent)
            toArr.append(result)
        }
    }
    // Aggregate All outputs received in the same transaction -- should be none
    for txidn in txidsReceived {
        let txid = txidn.components(separatedBy: "_")[0]
        let predicate = NSPredicate(format: "txidNReceived BEGINSWITH %@", txid)
        let filteredRes = results.filter(predicate)
        
        
        var totalAmount = 0
        for trans in filteredRes {
            guard let amount = trans.amount.value else {continue}
            totalAmount += amount
        }
        var amountAsDouble = Double(totalAmount) / Double(100000000)
        guard let blockNumber = filteredRes[0].blockReceived.value else {continue}
        data.append(transCellItem(type: "Received", amount: String(describing: amountAsDouble), blockNumber: String(describing: blockNumber), txid: txid))
        
    }
    
    var alreadyUsed = [String]()
    // Aggregate All inputs used in the same transaction
    for txid in txidsSent { // This is the transaction that the utxo was spent in, multiple utxos can be spent in the same transaction.
        if alreadyUsed.contains(txid) {
         continue
        }
        alreadyUsed.append(txid)
        let predicate = NSPredicate(format: "txidNSent BEGINSWITH %@", txid)
        let filteredRes = results.filter(predicate)
        
        var totalAmount = 0
        for trans in filteredRes {
            guard let amount = trans.amount.value else {continue}
            totalAmount += amount
        }
        let amountAsDouble = Double(totalAmount) / Double(100000000)
        guard let blockNumber = filteredRes[0].blockSent.value else {continue}
        data.append(transCellItem(type: "Sent", amount: String(describing: amountAsDouble), blockNumber: String(describing: blockNumber), txid: txid))
        
    }
    
    // abstract away change address, so it just looks like the user sent coins
    // This assumes that there will only be one input address and there will not be multiple addresses in one input
    var indicesOfRecTransactionsToRemove = [Int]()
    for index in data.indices {
        for index2 in data.indices {
            var item = data[index]
            var item2 = data[index2]
            
            if item.type == "Sent" && item2.type == "Received"{
                // check if they have same tx, aggregate if yes
         
                var tx = item.txid.components(separatedBy: "_")[0]
                var tx2 = item2.txid.components(separatedBy: "_")[0]
                
                if tx == tx2 {
                    let amountSent = Double(item.amount)
                    let amountReceived = Double(item2.amount)
                    
                    data[index].amount = String(describing: amountSent! - amountReceived!)
                    indicesOfRecTransactionsToRemove.append(index2)
                   
                    print("Transactiton Same, ", tx)
                }
            }
        }
    }
    
data.remove(at: indicesOfRecTransactionsToRemove)

    
    
    return data
}

func getCoinTotalBalance(_ data : Results<RealmModel_Transaction>) -> Double{
    var total : Double = 0
    if data[0].asset?.type != "NEP5" {
        total = sumUTXOBasedTransaction(results: data)
    } else {
        total = sumNEP5Transactions(results: data)
    }
    
    
    return total
    
}

func CalculateInputsNeeded(transactions : Results<RealmModel_Transaction>, total : Int64) -> (inputs:[RealmModel_Transaction]?,change:Int64) {
    
    // fee gets appended to running total if asset is gas total + fee
    // if asset not gas then fe calculated seperately
    var runningTotal = total
    var setOfInputs = [RealmModel_Transaction]()
    var change = Int64(0)
    for trans in transactions {
        
        if trans.txidNSent != nil {
            continue
        }
        
        if runningTotal <= 0 {
            break
        }
        guard let val = trans.amount.value else {continue}
        runningTotal = runningTotal - Int64(val)
        setOfInputs.append(trans)
    }
    if runningTotal > 0 {
        return (nil,change) // This should not happen as we will not allow users to enter more than they have.
    }
    if runningTotal < 0 {
        change = abs(runningTotal)
    }
    return (setOfInputs,change)
}

func FormTransactionFromInputs(inputs:[RealmModel_Transaction],changeAmount:Int64, scriptHash: String, fromAddr : RealmModel_Account, toAddr : String, total : Int64) -> Transaction?{
            guard let change = fromAddr.external.value, let index = fromAddr.index.value else {return nil}
            guard let from = fromAddr.address else {return nil}
            var contract = Transaction(TransType: 128)
    
            for input in inputs {
                guard let prevHashN = input.txidNReceived else {return nil}
                let prevHashNArr = prevHashN.components(separatedBy: "_")
                let prevHash = String(prevHashNArr[0].dropFirst(2))
                guard var vout = Int(prevHashNArr[1]) else {return nil}
                print("Prev Hash and VOUT", prevHash, vout)
                contract.Inputs.append(Input(PrevHash: prevHash, PrevIndex: vout, Address: from, External: change, Index: index))
            }

            contract.Outputs.append(Output(Address: toAddr, Value: total, AssetID: scriptHash))
            if changeAmount > 0 {
                contract.Outputs.append(Output(Address: from, Value: changeAmount, AssetID: scriptHash))
            }
            return contract
}
