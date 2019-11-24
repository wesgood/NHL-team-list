//
//  SideMenuTeamViewController.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuTeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var table: UITableView!
    
    var teams: [Team]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register a default cell
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        loadTeams()
    }
    
    /// Request the teams from the DataModel and update the table
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
            cell.imageView?.sd_setImage(with: team.logoUrl(), completed: { (_, _, _, _) in
                // force the table to reload the cell to properly render the image
                tableView.reloadRows(at: [indexPath], with: .none)
            })
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // send the selected team with a broadcast notification
        if let team = teams?[indexPath.row] {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "teamSelected"), object: team)
            dismiss(animated: true, completion: nil)
        }
    }
    
}
