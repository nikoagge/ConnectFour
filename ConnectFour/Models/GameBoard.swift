//
//  GameBoard.swift
//  ConnectFour
//
//  Created by Nikos Aggelidis on 9/7/23.
//

import UIKit
import GameplayKit

enum ChipColor: Int {
    case none = 0
    case red
    case green
}

final class GameBoard {
    static var width = 7
    static var height = 6
    
    var currentPlayer: Player
    var slots = [ChipColor]()

    init() {
        currentPlayer = Player.allPlayers[0]
        for _ in 0 ..< GameBoard.width * GameBoard.height {
            slots.append(.none)
        }
    }
    
    func chip(
        inColumn column: Int,
        row: Int
    ) -> ChipColor {
        return slots[row + column * GameBoard.height]
    }

    func set(
        chip: ChipColor,
        in column: Int,
        row: Int
    ) {
        slots[row + column * GameBoard.height] = chip
    }
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< GameBoard.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }

        return nil
    }
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    func add(
        chip: ChipColor,
        in column: Int
    ) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    func isFull() -> Bool {
        for column in 0 ..< GameBoard.width {
            if canMove(in: column) {
                return false
            }
        }

        return true
    }

    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chip = (player as! Player).chip

        for row in 0 ..< GameBoard.height {
            for col in 0 ..< GameBoard.width {
                if squaresMatch(
                    initialChip: chip,
                    row: row, column: col,
                    moveX: 1,
                    moveY: 0
                ) {
                    return true
                } else if squaresMatch(
                    initialChip: chip,
                    row: row,
                    column: col,
                    moveX: 0,
                    moveY: 1
                ) {
                    return true
                } else if squaresMatch(
                    initialChip: chip,
                    row: row, column: col,
                    moveX: 1,
                    moveY: 1
                ) {
                    return true
                } else if squaresMatch(
                    initialChip: chip,
                    row: row,
                    column: col,
                    moveX: 1,
                    moveY: -1
                ) {
                    return true
                }
            }
        }

        return false
    }
    
    func squaresMatch(
        initialChip: ChipColor,
        row: Int,
        column: Int,
        moveX: Int,
        moveY: Int
    ) -> Bool {
        if row + (moveY * 3) < 0 { return false }
        if row + (moveY * 3) >= GameBoard.height { return false }
        if column + (moveX * 3) < 0 { return false }
        if column + (moveX * 3) >= GameBoard.width { return false }

        if chip(inColumn: column, row: row) != initialChip { return false }
        if chip(inColumn: column + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: column + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: column + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }

        return true
    }
}
