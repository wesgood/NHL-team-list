//
//  PeopleResponse.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class PeopleResponse: NSObject, Mappable {
    var players: [Player]!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        players <- map["teams.0.roster.roster"]
    }
}
