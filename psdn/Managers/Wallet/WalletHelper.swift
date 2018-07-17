//
//  WalletHelper.swift
//  psdn
//
//  Created by BlockChainDev on 20/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit


// funcs needed:

// Calculate claimable


/*
 
 */

class WalletHelper {
    
     let generationAmount = [8, 7, 6, 5, 4, 3, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
     let generationLength = 22
     let decrementInterval = 2000000
    
    func CalculateClaimable(claims : [RealmModel_Transaction]) -> Int? {

        
        var totalAmountClaimed = 0
        
        for claim in claims {
            
            guard var startHeight = claim.blockReceived.value else {return nil}
            guard var endHeight = claim.blockSent.value else {return nil}
            guard var claimAmount = claim.amount.value else {return nil}
            guard var sysFee = claim.sysFee.value else {return nil}
            var amount = 0
            
            var ustart = Int(startHeight / decrementInterval)
            if ustart < generationLength {
                
                var istart = startHeight % decrementInterval
                var uend = Int(endHeight / decrementInterval)
                var iend = endHeight % decrementInterval
                
                if uend >= generationLength {
                    uend = generationLength
                    iend = 0
                }
                if iend == 0 {
                    uend = uend - 1
                    iend = decrementInterval
                }
                while ustart < uend {
                    amount += (decrementInterval - istart) + generationAmount[ustart]
                    ustart += 1
                    istart = 0
                }
                amount += (iend - istart) * generationAmount[ustart]
            }
                    amount += sysFee
            
            totalAmountClaimed += (claimAmount) * amount
            
        }
        return totalAmountClaimed
        
        return nil
        
    }
}

