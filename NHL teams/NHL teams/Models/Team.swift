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
    var name: String!
    var players: [Player]?
    var logo: String?
    var teamId: Int!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        teamId <- map["id"]
        logo <- map["logo"]
    }
    
    func sortedPlayers(_ sort: DataModel.TeamSort) -> [Player] {
        if players == nil {
            return []
        }
        
        switch sort {
        case .name:
            return players!.sorted(by: { $0.name < $1.name })
        case .number:
            return players!.sorted(by: { $0.number < $1.number })
        }
    }
}
