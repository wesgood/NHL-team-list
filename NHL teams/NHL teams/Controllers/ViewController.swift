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
    @IBOutlet var sortSegmentedControl: UISegmentedControl!
    @IBOutlet var filterButton: UIButton!
    
    var team: Team?
    var sortedPlayers: [Player]?
    var selectedSort: DataModel.TeamSort = .name
    var positionFilter: String?
    
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
        
        showBanner()
        
        loadTeam()
    }
    
    func loadTeam() {
        if team == nil {
            return
        }
        
        DataModel.shared.getTeam(team: team!, complete: {(team, error) in
            if error != nil {
                self.showAlert(title: "Download error", message: error!)
                return
            }
            
            self.team = team
            self.sortedPlayers = team!.sortedPlayers(self.selectedSort, filter: self.positionFilter)
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
    
    // MARK: Sort and filter methods
    
    @IBAction func segmentChanged() {
        let sortingMethods: [DataModel.TeamSort] = [.name, .number]
        self.selectedSort = sortingMethods[sortSegmentedControl.selectedSegmentIndex]
        loadTeam()
    }
    
    @IBAction func onFilterButton() {
        let sheet = UIAlertController(title: "Select position", message: nil, preferredStyle: .actionSheet)
        
        for position in DataModel.shared.positions.sorted() {
            let action = UIAlertAction(title: position, style: .default) { (action) in
                self.positionFilter = position
                self.updatePositionFilterButton()
                self.loadTeam()
            }
            sheet.addAction(action)
        }
        
        let clearAction = UIAlertAction(title: "Clear selection", style: .destructive) { (action) in
            self.positionFilter = nil
            self.updatePositionFilterButton()
            self.loadTeam()
        }
        sheet.addAction(clearAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        self.present(sheet, animated: true, completion: nil)
    }
    
    func updatePositionFilterButton() {
        if positionFilter == nil {
            filterButton.setTitle("Filter by position", for: .normal)
        } else {
            filterButton.setTitle("Filtering by position: \(positionFilter!)", for: .normal)
        }
    }

    // MARK: Table delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        if let player = self.sortedPlayers?[indexPath.row] {
            cell.render(player: player)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let player = sortedPlayers?[indexPath.row] {
            let controller = PlayerViewController(player: player)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // MARK: Banner
    
    /// Show a team spirit banner
    func showBanner() {
        if team?.teamId != 10 {
            return
        }
        
        let container = UIView(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY - 48, width: self.view.frame.size.width, height: 48))
        container.backgroundColor = UIColor(red: 0, green: 32/255.0, blue: 91/255.0, alpha: 1.0)
        
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.text = "Go Leafs Go"
        label.textColor = UIColor.white
        label.sizeToFit()
        label.textAlignment = .center
        label.center = CGPoint(x: container.frame.size.width/2, y: container.frame.size.height/2)
        container.addSubview(label)
        
        self.view.addSubview(container)
        
        toggleTeamBanner(container, show: true)
    }
    
    /// Move the team banner up or down
    /// - Parameters:
    ///   - container: container of the banner
    ///   - show: toggle show or hide
    func toggleTeamBanner(_ container: UIView, show: Bool) {
        UIView.animate(withDuration: 0.75, animations: {
            var frame = container.frame
            if show {
                frame.origin.y = self.navigationController!.navigationBar.frame.maxY
            } else {
                frame.origin.y = self.navigationController!.navigationBar.frame.maxY - container.frame.size.height
            }
            container.frame = frame
        }) { (complete) in
            if show {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.toggleTeamBanner(container, show: false)
                }
            } else {
                container.removeFromSuperview()
            }
        }
    }
}

