//
//  ConnectFourViewController.swift
//  ConnectFour
//
//  Created by Nikos Aggelidis on 9/7/23.
//

import UIKit

import UIKit

final class ConnectFourViewController: UIViewController {
    private var contentView = UIView.newAutoLayout()
    
    let numRows = 6
    let numColumns = 7
    
    var gameBoard: [[Player]] = []
    var currentPlayer: Player = .player1
    var gameOver: Bool = false
    
    var boardButtons: [[UIButton]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        createGameBoard()
    }
    
    func createGameBoard() {
        let boardSize: CGFloat = min(view.bounds.width, view.bounds.height)
        let buttonSize: CGFloat = boardSize / CGFloat(numColumns + 2)
        let boardOffset: CGFloat = (view.bounds.height - boardSize) / 2.0
        
        gameBoard = Array(repeating: Array(repeating: .none, count: numColumns), count: numRows)
        
        for row in 0..<numRows {
            var rowButtons: [UIButton] = []
            for column in 0..<numColumns {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: buttonSize + CGFloat(column) * buttonSize,
                                      y: boardOffset + CGFloat(row) * buttonSize,
                                      width: buttonSize,
                                      height: buttonSize)
                button.backgroundColor = .lightGray
                button.layer.cornerRadius = buttonSize / 2
                button.tag = column
                button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
                contentView.addSubview(button)
                
                rowButtons.append(button)
            }
            
            boardButtons.append(rowButtons)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let column = sender.tag

        if !gameOver {
            if let row = lowestAvailableRow(in: column) {
                gameBoard[row][column] = currentPlayer
                updateButtonColor(row: row, column: column)
                checkWin(row: row, column: column)
                switchPlayers()
            }
        }
    }

    func lowestAvailableRow(in column: Int) -> Int? {
        for row in (0..<numRows).reversed() {
            if gameBoard[row][column] == .none {
                return row
            }
        }
        return nil
    }

    func updateButtonColor(row: Int, column: Int) {
        let button = boardButtons[row][column]
        button.backgroundColor = (currentPlayer == .player1) ? .red : .yellow
    }
    
    func checkWin(row: Int, column: Int) {
        let player = gameBoard[row][column]
        
        // Check horizontal
        var count = 1
        count += countConsecutiveChips(in: row, column: column, rowDir: 0, colDir: 1)
        count += countConsecutiveChips(in: row, column: column, rowDir: 0, colDir: -1)
        if count >= 4 {
            gameOver = true
            let winner = (player == .player1) ? "Player 1" : "Player 2"
            showAlert(title: "Game Over", message: "\(winner) wins!")
            return
        }
        
        // Check vertical
        count = 1
        count += countConsecutiveChips(in: row, column: column, rowDir: 1, colDir: 0)
        count += countConsecutiveChips(in: row, column: column, rowDir: -1, colDir: 0)
        if count >= 4 {
            gameOver = true
            let winner = (player == .player1) ? "Player 1" : "Player 2"
            showAlert(title: "Game Over", message: "\(winner) wins!")
            return
        }
        
        // Check diagonal /
        count = 1
        count += countConsecutiveChips(in: row, column: column, rowDir: 1, colDir: 1)
        count += countConsecutiveChips(in: row, column: column, rowDir: -1, colDir: -1)
        if count >= 4 {
            gameOver = true
            let winner = (player == .player1) ? "Player 1" : "Player 2"
            showAlert(title: "Game Over", message: "\(winner) wins!")
            return
        }
        
        // Check diagonal \
        count = 1
        count += countConsecutiveChips(in: row, column: column, rowDir: 1, colDir: -1)
        count += countConsecutiveChips(in: row, column: column, rowDir: -1, colDir: 1)
        if count >= 4 {
            gameOver = true
            let winner = (player == .player1) ? "Player 1" : "Player 2"
            showAlert(title: "Game Over", message: "\(winner) wins!")
            return
        }
        
        // Check draw
        let isBoardFull = gameBoard.allSatisfy { row in
            return row.allSatisfy { $0 != .none }
        }
        
        if isBoardFull && !gameOver {
            gameOver = true
            showAlert(title: "Game Over", message: "It's a draw!")
            return
        }
    }
    
    func countConsecutiveChips(in row: Int, column: Int, rowDir: Int, colDir: Int) -> Int {
        var count = 0
        var r = row + rowDir
        var c = column + colDir
        
        while r >= 0 && r < numRows && c >= 0 && c < numColumns && gameBoard[r][c] == gameBoard[row][column] {
            count += 1
            r += rowDir
            c += colDir
        }
        
        return count
    }
    
    func switchPlayers() {
        currentPlayer = (currentPlayer == .player1) ? .player2 : .player1
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let restartAction = UIAlertAction(title: "Restart", style: .default) { _ in
            self.resetGame()
        }
        alert.addAction(restartAction)
        present(alert, animated: true, completion: nil)
    }
    
    func resetGame() {
        for row in 0..<numRows {
            for column in 0..<numColumns {
                gameBoard[row][column] = .none
                let button = boardButtons[row][column]
                button.backgroundColor = .lightGray
            }
        }
        
        currentPlayer = .player1
        gameOver = false
    }
}

enum Player {
    case none
    case player1
    case player2
}



// MARK: - Private Functions

private extension ConnectFourViewController {
    func setupUI() {
        view.addSubview(contentView)
        contentView.fillToSuperview()
        contentView.backgroundColor = .systemPink
    }
}
