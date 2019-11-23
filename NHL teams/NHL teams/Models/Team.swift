//
//  Team.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class Team: NSObject, Mappable {
    var name: String?
    var players: String?
    var logo: String?
    var teamId: Int?
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        teamId <- map["id"]
        players <- map["players"]
        logo <- map["logo"]
    }
}
