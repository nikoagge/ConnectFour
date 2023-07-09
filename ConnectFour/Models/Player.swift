//
//  Player.swift
//  ConnectFour
//
//  Created by Nikos Aggelidis on 9/7/23.
//

import UIKit
import GameplayKit

final class Player: NSObject, GKGameModelPlayer {
    var chip: ChipColor
    var color: UIColor
    var name: String
    var playerId: Int
    
    var opponent: Player {
        return chip == .red ? .allPlayers[1] : .allPlayers[0]
    }

    static var allPlayers = [
        Player(chip: .red),
        Player(chip: .green)
    ]
    
    init(chip: ChipColor) {
        self.chip = chip
        self.playerId = chip.rawValue
        color = chip == .red ? .red : .green
        name = chip == .red ? "Red" : "Green"

        super.init()
    }
}
