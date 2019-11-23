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
    var name: String?
    var country: String?
    var photo: String?
    var playerId: Int?
    var dob: Date?
    var number: Int?
    var position: String?
    
    required init?(map: Map) {
        super.init()
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        name <- map["name"]
        country <- map["country"]
        photo <- map["photo"]
        playerId <- map["id"]
        dob <- map["date_of_birth"]
        number <- map["number"]
        position <- map["position"]
    }
}
