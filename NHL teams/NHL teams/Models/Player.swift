//
//  Player.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import ObjectMapper

class Player: NSObject, Mappable {
    var name: String!
    var country: String?
    var playerId: Int!
    var dob: Date?
    var number: Int!
    var position: String!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        // these values are in the list
        name <- map["person.fullName"]
        playerId <- map["person.id"]
        position <- map["position.name"]
        number <- (map["jerseyNumber"], JsonIntTransformer())
        
        // when loading from the individual player request, different properties are required
        if playerId == nil {
            playerId <- map["id"]
            name <- map["fullName"]
            position <- map["primaryPosition.name"]
            number <- (map["primaryNumber"], JsonIntTransformer())
        }
        
        country <- map["nationality"]
        dob <- (map["birthDate"], JsonDateTransformer())
    }
    
    /// Use the researched API to find the portrait URL
    func portraitUrl() -> URL {
        let urlString = "https://nhl.bamcontent.com/images/headshots/current/168x168/\(String(describing: playerId!)).jpg"
        return URL(string: urlString)!
    }
}
