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
    var number: String!
    var position: String!
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        // these values are in the list
        name <- map["person.fullName"]
        playerId <- map["person.id"]
        position <- map["position.code"]
        number <- map["jerseyNumber"]
        
        if playerId == nil {
            playerId <- map["id"]
            name <- map["fullName"]
            position <- map["primaryPosition.name"]
            number <- map["primaryNumber"]
        }
        
        country <- map["birthCountry"]
        dob <- (map["birthDate"], JsonDateTransformer())
    }
    
    func portraitUrl() -> URL {
        let urlString = "https://nhl.bamcontent.com/images/headshots/current/168x168/\(String(describing: playerId!)).jpg"
        return URL(string: urlString)!
    }
    
    func flagUrl() -> URL? {
        if country == nil {
            return nil
        }
        let urlString = "https://restcountries.eu/rest/v2/alpha/\(country!).svg"
        return URL(string: urlString)
    }
}
