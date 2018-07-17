//
//  Aray+Extensions.swift
//  psdn
//
//  Created by BlockChainDev on 10/07/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import UIKit

extension Array {
    mutating func remove(at indexes: [Int]) {
        var lastIndex: Int? = nil
        for index in indexes.sorted(by: >) {
            guard lastIndex != index else {
                continue
            }
            remove(at: index)
            lastIndex = index
        }
    }
}
