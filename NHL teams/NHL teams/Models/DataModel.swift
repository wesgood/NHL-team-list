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
    func getTeams(complete: @escaping ((_ : [Team]?, _ : String?) -> Void)) {
        // check for the local cache
        if !teams.isEmpty {
            complete(teams, nil)
            return
        }
        
        // if the list is empty, call the API
        AF.request(NHLRouter.getTeams(params: [:]))
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<TeamResponse, AFError>) in
                    switch response.result {
                    case .success:
                        do {
                        guard let teamList = try response.result.get().teams else {
                            complete(nil, "Unable to load teams")
                            break
                        }
                            self.teams = teamList.sorted(by: { $0.name < $1.name })
                            complete(self.teams, nil)
                        } catch {
                            complete(nil, "Unable to load teams")
                        }
                    case .failure:
                        if let error = response.error {
                            complete(nil, error.localizedDescription)
                        }
                    }
                }
    }
    
    /// Search the local list of teams or use the API if necessary
    /// - Parameters:
    ///   - id: int value of team ID
    ///   - sort: enum value of the requested sort order
    ///   - complete: callback that returns the team or an error message
    func getTeam(team: Team, sort: TeamSort = .name, complete: @escaping ((_ : Team?, _ : String?) -> Void)) {
        if team.players != nil {
            team.players = team.sortedPlayers(sort)
            complete(team, nil)
            return
        }
        
        // if the list is empty, call the API
        AF.request(NHLRouter.getTeam(id: team.teamId))
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<PeopleResponse, AFError>) in
                    switch response.result {
                    case .success:
                        do {
                        guard let teamList = try response.result.get().players else {
                            complete(nil, "Unable to load players")
                            break
                        }
                            team.players = teamList
                            team.players = team.sortedPlayers(sort)
                            complete(team, nil)
                        } catch {
                            complete(nil, "Unable to load players")
                        }
                    case .failure:
                        if let error = response.error {
                            complete(nil, error.localizedDescription)
                        }
                    }
                }
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
    
    enum NHLRouter: URLRequestConvertible {
        case getTeams(params: Parameters)
        case getTeam(id: Int)
        case getPlayer(id: Int)
        
        static let baseURLString = "https://statsapi.web.nhl.com/api/v1/"
        
        func asURLRequest() throws -> URLRequest {
            let result: (path: String, parameters: Parameters) = {
                switch self {
                case let .getTeams(params):
                    return ("/teams", params)
                case let .getTeam(id):
                    return ("/teams/\(id)", ["expand" : "team.roster"])
                case let .getPlayer(id):
                    return ("/people/\(id)", [:])
                }
            }()
            
            let url = try NHLRouter.baseURLString.asURL()
            let urlRequest = URLRequest(url: url.appendingPathComponent(result.path))
            
            return try URLEncoding.default.encode(urlRequest, with: result.parameters)
        }
    }
}
