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
    var positions = [String]()
    
    enum TeamSort: String {
        case name
        case number
        case position
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
            .responseObject { (response: DataResponse<TeamListResponse, AFError>) in
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
    ///   - complete: callback that returns the team or an error message
    func getTeam(team: Team, complete: @escaping ((_ : Team?, _ : String?) -> Void)) {
        AF.request(NHLRouter.getTeam(id: team.teamId))
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<SingleTeamResponse, AFError>) in
                    switch response.result {
                    case .success:
                        do {
                        guard let team = try response.result.get().team else {
                            complete(nil, "Unable to load players")
                            break
                        }
                            
                            if let players = team.players {
                                self.savePositions(players)
                            }
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
        
    /// Get specific player from the cache or API
    /// - Parameters:
    ///   - id: int value of the player ID
    ///   - complete: callback of the player or error message
    func getPlayer(id: Int, complete: @escaping ((_ : Player?, _ : String?) -> Void)) {
        // we always call the API to make sure we have the latest
        AF.request(NHLRouter.getPlayer(id: id))
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<SinglePlayerResponse, AFError>) in
                switch response.result {
                case .success:
                    do {
                        guard let player = try response.result.get().player else {
                            complete(nil, "Unable to load player")
                            break
                        }
                        
                        complete(player, nil)
                    } catch {
                        complete(nil, "Unable to load player")
                    }
                case .failure:
                    if let error = response.error {
                        complete(nil, error.localizedDescription)
                    }
                }
        }
    }
    
    /// Save the positions that come in from the API
    /// - Parameter players: array of players to look for positions
    func savePositions(_ players: [Player]) {
        for player in players {
            if !self.positions.contains(player.position) {
                self.positions.append(player.position)
            }
        }
    }
    
    // MARK: Country methods
    
    func getCountry(code: String, complete: @escaping ((_ : Country?, _ : String?) -> Void)) {
        AF.request("https://restcountries.eu/rest/v2/alpha/\(code)")
            .validate(statusCode: 200..<300)
            .responseObject { (response: DataResponse<Country, AFError>) in
                switch response.result {
                case .success:
                    do {
                        let country = try response.result.get()                        
                        complete(country, nil)
                    } catch {
                        complete(nil, "Unable to load country")
                    }
                case .failure:
                    if let error = response.error {
                        complete(nil, error.localizedDescription)
                    }
                }
        }
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
