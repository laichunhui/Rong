//
//  Data+Extensions.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 10/1/22.
//

import Foundation

public extension Encodable {
    func toData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

public extension Data {
    func toObject<D: Decodable>() throws -> D {
        try JSONDecoder().decode(D.self, from: self)
    }
}
