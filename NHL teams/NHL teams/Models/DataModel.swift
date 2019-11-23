//
//  DataModel.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class DataModel: NSObject {
    static let shared = DataModel()
    
    var teams = [Team]()
    var players = [Player]()
    
    enum TeamSort: String {
        case name
        case number
    }
    
    enum PositionFilter: String {
        case forward
        case defence
        case goalie
    }
    
    // MARK: Team methods
    
    /// Get a list of sorted teams - from the cache or API as needed
    /// - Parameter complete: callback that returns either the teams or an error message
    func getTeams(complete: ((_ : [Team]?, _ : String?) -> Void)) {
        // check for the local cache
        if !teams.isEmpty {
            complete(teams, nil)
            return
        }
        
        // if the list is empty, call the API
    }
    
    /// Search the local list of teams or use the API if necessary
    /// - Parameters:
    ///   - id: int value of team ID
    ///   - sort: enum value of the requested sort order
    ///   - complete: callback that returns the team or an error message
    func getTeam(id: Int, sort: TeamSort = .name, complete: ((_ : Team?, _ : String?) -> Void)) {
        
    }
    
    // MARK: Player methods
    
    /// Get players
    /// - Parameters:
    ///   - teamId: int value of team ID
    ///   - position: position filter enum
    ///   - sort: enum value of the requested sort order
    ///   - complete: callback that returns the players or an error message
    func getPlayers(teamId: Int, position: PositionFilter?, sort: TeamSort = .name, complete: ((_ : [Player], _ : String?) -> Void)) {
        
    }
    
    /// Get specific player from the cache or API
    /// - Parameters:
    ///   - id: int value of the player ID
    ///   - complete: callback of the player or error message
    func getPlayer(id: Int, complete: ((_ : Player?, _ : String?) -> Void)) {
        
    }
    
    // MARK: API methods
    
}
