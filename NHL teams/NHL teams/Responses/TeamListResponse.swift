//
//  TeamResponse.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class TeamListResponse: NSObject, Mappable {
    var teams: [Team]!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        teams <- map["teams"]
    }
}
