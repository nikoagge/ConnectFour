//
//  ConnectFourViewController.swift
//  ConnectFour
//
//  Created by Nikos Aggelidis on 9/7/23.
//

import UIKit

final class ConnectFourViewController: UIViewController {
    @IBOutlet var columnButtons: [UIButton]!

    private var placedChips = [[UIView]]()
    private var gameBoard: GameBoard!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializePlacedChips()
        resetGameBoard()
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
      let column = sender.tag

        if let row = gameBoard.nextEmptySlot(in: column) {
            gameBoard.add(chip: gameBoard.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: gameBoard.currentPlayer.color)
            continueGame()
        }
    }
}

// MARK: - Private Functions

private extension ConnectFourViewController {
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })

            placedChips[column].append(newChip)
        }
    }
    
    func continueGame() {
        var gameOverTitle: String? = nil
        
        if gameBoard.isWin(for: gameBoard.currentPlayer) {
            gameOverTitle = "\(gameBoard.currentPlayer.name) Wins!"
        } else if gameBoard.isFull() {
            gameOverTitle = "Draw!"
        }
        
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetGameBoard()
            }

            alert.addAction(alertAction)
            present(alert, animated: true)
        }

        gameBoard.currentPlayer = gameBoard.currentPlayer.opponent
        updateUI()
    }

    func initializePlacedChips() {
        for _ in 0 ..< GameBoard.width {
            placedChips.append([UIView]())
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)

        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    func resetGameBoard() {
        gameBoard = GameBoard()
        updateUI()

        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }

            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    func updateUI() {
        title = "\(gameBoard.currentPlayer.name)'s Turn"
    }
}
