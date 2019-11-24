//
//  PlayerTableViewCell.swift
//  NHL teams
//
//  Created by Wes Goodhoofd on 2019-11-23.
//  Copyright © 2019 Wes Goodhoofd. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    
    var player: Player?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(player: Player) {
        self.player = player
        
        nameLabel.text = player.name
        numberLabel.text = (player.number != nil ) ? String(describing: player.number!) : nil
        positionLabel.text = player.position
    }
}
