//
//  ViewController.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import SideMenu

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var table: UITableView!
    
    var team: Team?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // register a default cell
        self.table.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "playerCell")
        
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
    
    // pulled directly from the side menu library configuration
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sideMenuNavigationController = segue.destination as? SideMenuNavigationController else { return }
        sideMenuNavigationController.settings = makeSettings()
    }
    
    private func makeSettings() -> SideMenuSettings {
        let presentationStyle = SideMenuPresentationStyle.viewSlideOutMenuIn
        presentationStyle.onTopShadowOpacity = 0.6

        var settings = SideMenuSettings()
        settings.presentationStyle = presentationStyle
        settings.menuWidth = min(view.frame.width, view.frame.height) * 0.9

        return settings
    }

    // MARK: Table delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return team?.players?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        if let player = self.team?.players?[indexPath.row] {
            cell.render(player: player)
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

