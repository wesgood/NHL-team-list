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
    var teamId: Int!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        teamId <- map["id"]
        players <- map["roster.roster"]
    }
    
    /// Sort and filter the player list with the provided parameters
    /// - Parameters:
    ///   - sort: TeamSort value
    ///   - filter: string of the player's position
    func sortedPlayers(_ sort: DataModel.TeamSort, filter: String? = nil) -> [Player] {
        if players == nil {
            return []
        }
        
        var filtered = players
        
        // filter the player list if requested
        if filter != nil {
            filtered = players!.filter({ return $0.position == filter! })
        }
        
        switch sort {
        case .name:
            return filtered!.sorted(by: { $0.name < $1.name })
        case .number:
            return filtered!.sorted(by: { $0.number < $1.number })
        }
    }
    
    func logoUrl() -> URL {
        let urlString = "https://www-league.nhlstatic.com/images/logos/teams-current-primary-light/\(String(describing: teamId!)).svg"
        return URL(string: urlString)!
    }
}
