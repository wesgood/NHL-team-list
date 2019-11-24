//
//  JsonIntTransformer.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-24.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class JsonIntTransformer: NSObject, TransformType {
    typealias Object = Int
    typealias JSON = String

    override init() {}
    func transformFromJSON(_ value: Any?) -> Int? {
        if let strValue = value as? String {
            return Int(strValue)
        }
        return value as? Int ?? nil
    }

    func transformToJSON(_ value: Int?) -> String? {
        if let intValue = value {
            return "\(intValue)"
        }
        return nil
    }
}
