//
//  JsonDateTransformer.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class JsonDateTransformer: NSObject, TransformType {
    internal typealias Object = Date
    internal typealias JSON = String

    func transformFromJSON(_ value: Any?) -> Date? {
        if let dateString = value as? String {
            // formatter - ISO-8601 is first; all dates SHOULD use that format
            let formats = [
                "yyyy-MM-dd"
            ]

            let formatter = DateFormatter()

            for format in formats {
                formatter.timeZone = TimeZone.current
                formatter.dateFormat = format

                if let date = formatter.date(from: dateString) {
                    return date
                }
            }
            return nil
        } else {
            return nil
        }
    }

    func transformToJSON(_ value: Date?) -> JsonDateTransformer.JSON? {
        if value != nil {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"

            // timezone
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            return formatter.string(from: value!)
        } else {
            return nil
        }
    }
}
