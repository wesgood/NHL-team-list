//
//  SideMenuTeamViewController.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit

class SideMenuTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    var teams: [Team]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a default cell
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        loadTeams()
    }
    
    func loadTeams() {
        DataModel.shared.getTeams { (teams, error) in
            if error != nil {
                print(error!)
                return
            }
            
            self.teams = teams
            self.table.reloadData()
        }
    }
    
    // MARK: Table delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        if let team = self.teams?[indexPath.row] {
            cell.textLabel?.text = team.name
            // TODO - load team logo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // TODO - dismiss the table and show the team
    }
    
}
