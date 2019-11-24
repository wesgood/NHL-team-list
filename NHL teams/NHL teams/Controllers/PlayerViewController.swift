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

    func loadPlayerData() {
        nameLabel.text = player.name
        dobLabel.text = player.dob?.description
        countryLabel.text = player.country
        jerseyNumberLabel.text = String(describing: player.number)
        positionLabel.text = player.position
        
        // load their portrait
        portraitImageView.kf.setImage(with: player.portraitUrl())
        
        // load the flag
        countryFlagImageView.sd_setImage(with: player.flagUrl())
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
