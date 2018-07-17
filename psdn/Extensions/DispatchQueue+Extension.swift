//
//  DispatchQueue+Extension.swift
//  psdn
//
//  Created by BlockChainDev on 11/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func roundTrip<T, Y>(_ block: () throws -> T,
                                thenAsync: @escaping (T) throws -> Y,
                                thenOnMain: @escaping (T, Y) throws -> Void,
                                catchToMain: @escaping (Error) -> Void) {
        do {
            let resultFromMain = try block()
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let resultFromBackground = try thenAsync(resultFromMain)
                    DispatchQueue.main.async {
                        do {
                            try thenOnMain(resultFromMain, resultFromBackground)
                        } catch {
                            catchToMain(error)
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        catchToMain(error)
                    }
                }
            }
        } catch {
            catchToMain(error)
        }
    }
}
