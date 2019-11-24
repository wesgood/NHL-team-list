//
//  UIDate+Extensions.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit

extension Date {
    func format(_ formatString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatString
        return dateFormatter.string(from: self)
    }
}
