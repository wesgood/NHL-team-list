//
//  PlayerViewController.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit
import Kingfisher
import SDWebImage

class PlayerViewController: UIViewController {
    var player: Player!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var portraitImageView: UIImageView!
    @IBOutlet var dobLabel: UILabel!
    @IBOutlet var countryFlagImageView: UIImageView!
    @IBOutlet var countryLabel: UILabel!
    @IBOutlet var jerseyNumberLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    
    convenience init(player: Player) {
        self.init()
        self.player = player
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // display what data we have available
        loadPlayerData()
        
        DataModel.shared.getPlayer(id: player.playerId) { (player, error) in
            if error != nil {
                self.showAlert(title: "Download error", message: error!)
                return
            }
            
            self.player = player
            self.loadPlayerData()
        }
    }
    
    /// Update the view to include the selected player
    func loadPlayerData() {
        nameLabel.text = player.name
        dobLabel.text = player.dob?.format("MMMM d, YYYY")
        jerseyNumberLabel.text = (player.number != nil ) ? String(describing: player.number!) : nil
        positionLabel.text = player.position
        
        // load their portrait
        portraitImageView.kf.setImage(with: player.portraitUrl())
        
        // load the flag
        if let country = player.country {
            DataModel.shared.getCountry(code: country) { (country, error) in
                if error != nil {
                    print(error!)
                    return
                }

                self.countryLabel.text = country!.name
                self.countryFlagImageView.sd_setImage(with: URL(string: country!.flag))
            }
        }
    }
}
