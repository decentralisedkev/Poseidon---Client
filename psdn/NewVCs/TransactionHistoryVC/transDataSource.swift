//
//  transDataSource.swift
//  psdn
//
//  Created by BlockChainDev on 26/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//


import UIKit
import RealmSwift
class transDatsSource: baseDataSource {
    
    var data : Results<RealmModel_Transaction>!
  
    var cellItems : [transCellItem] = [transCellItem]()
    
    var headerData : String = "No Data"
    
    override func numberOfItems(_ section: Int) -> Int {
        return cellItems.count
    }
    
    override func headerItem(_ section: Int) -> Any? {
        return headerData
    }
    
    override func cellClasses() -> [baseViewCell.Type] {
        return [transCellView.self]
    }
    
    override func headerClasses() -> [baseViewCell.Type]? {
        return [transHeaderCellView.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return cellItems[indexPath.item]
    }
    
    init(_ transactionsData: Results<RealmModel_Transaction>) {
        super.init()
        self.data = transactionsData
        requestData()
        print("We have data in datasource")
    }
    
    func requestData() {
        print("Transaction history")
         guard let symbol = data[0].asset?.symbol else {return}
        var total = getCoinTotalBalance(data)
        headerData = String(describing: total) + " " + symbol
        // We now have either all NEO transactions or some token type
        // We should find out if it is a utxo first and then process the data accordingly
        if data[0].asset?.type != "NEP5" {
            cellItems = utxoToTransCellItem(results: data)
        } else {
            cellItems = nep5ToTransCellItem(results: data)
        }
        cellItems = cellItems.sorted(by: { (a, b) -> Bool in
            return a.blockNumber > b.blockNumber
        })
        
    }
    

    
}
