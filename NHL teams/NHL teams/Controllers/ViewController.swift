//
//  ViewController.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var table: UITableView!
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // register a default cell
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "defaultCell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(teamSelected), name: NSNotification.Name(rawValue: "teamSelected"), object: nil)
    }
    
    @objc func teamSelected(_ notification: Notification) {
        guard let team = notification.object as? Team else {
            return
        }
        
        self.team = team
        
        loadTeam()
    }
    
    func loadTeam() {
        DataModel.shared.getTeam(team: team!, sort: .name, complete: {(team, error) in
            if error != nil {
                self.showAlert(title: "Download error", message: error!)
                return
            }
            
            self.team = team
            self.table.reloadData()
        })
    }

    // MARK: Table delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        if let player = self.team?.players?[indexPath.row] {
            cell.textLabel?.text = player.name
            // TODO - load team logo
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let player = team?.players?[indexPath.row] {
            let controller = PlayerViewController(player: player)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

