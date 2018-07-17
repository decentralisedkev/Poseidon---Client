//
//  Codable+Extension.swift
//  psdn
//
//  Created by BlockChainDev on 07/06/2018.
//  Copyright © 2018 kwopltd. All rights reserved.
//

import Foundation

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(self)
    }
}

extension Decodable {
    static func decode(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws -> Self {
        return try decoder.decode(Self.self, from: data)
    }
}
