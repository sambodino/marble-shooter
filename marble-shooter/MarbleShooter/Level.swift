//
//  Level.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/9/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import Foundation

//TODO: move these to GameScene if we dont end up using level
let NumColumns = 11
let NumRows = 20

class Level {
//    fileprivate var balls = Matrix<Ball>(columns: NumColumns, rows: NumRows)
//
//    init(filename: String) {
//        // 1
//        guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename: filename) else { return }
//        // 2
//        guard let slotsArray = dictionary["slots"] as? [[Int]] else { return }
//        // 3
//        for (row, rowArray) in slotsArray.enumerated() {
//            // 4
//            let slotRow = NumRows - row - 1
//            // 5
//            for (column, value) in rowArray.enumerated() {
//                if value == 1 {
//                    slots[column, slotRow] = Slot()
//                }
//            }
//        }
//    }
//    
//    func ballAt(column: Int, row: Int) -> Ball? {
//        //use of assert() to verify that the specified
//        //column and row numbers are within the valid range
//        assert(column >= 0 && column < NumColumns)
//        assert(row >= 0 && row < NumRows)
//        return balls[column, row]
//    }
//    
//    func shuffle() -> Set<Ball> {
//        return createInitialBalls()
//    }
//    
//    private func createInitialBalls() -> Set<Ball> {
//        var set = Set<Ball>()
//        
//        for row in 0..<NumRows {
//            for column in 0..<NumColumns {
//                if slots[column, row] != nil {
//                    //var ballType = BallType.random()
//                    //pick a random ball but make sure never to create chain of three or more
//                    var ballType: BallType
//                    repeat {
//                        ballType = BallType.random()
//                    } while (column >= 2 &&
//                        balls[column - 1, row]?.ballType == ballType &&
//                        balls[column - 2, row]?.ballType == ballType)
//                        || (row >= 2 &&
//                            balls[column, row - 1]?.ballType == ballType &&
//                            balls[column, row - 2]?.ballType == ballType)
//                //was getting an error
//                    let ball = Ball(column: column, row: row, ballType: ballType)
//                    balls[column, row] = ball
//                
//                    set.insert(ball)
//                }
//            }
//        }
//        return set
//    }
//    
//    private var slots = Matrix<Slot>(columns: NumColumns, rows: NumRows)
//    
//    func slotAt(column: Int, row: Int) -> Slot? {
//        assert(column >= 0 && column < NumColumns)
//        assert(row >= 0 && row < NumRows)
//        return slots[column, row]
    }
    /*
    //check if there is a chain of same colored balls
    private func hasChainAt(column: Int, row: Int) -> Bool {
        let ballType = balls[column, row]!.ballType
        
        // Horizontal chain check
        var horzLength = 1
        
        // Left
        var i = column - 1
        while i >= 0 && balls[i, row]?.ballType == ballType {
            i -= 1
            horzLength += 1
        }
        
        // Right
        i = column + 1
        while i < NumColumns && balls[i, row]?.ballType == ballType {
            i += 1
            horzLength += 1
        }
        if horzLength >= 3 { return true }
        
        // Vertical chain check
        var vertLength = 1
        
        // Down
        i = row - 1
        while i >= 0 && balls[column, i]?.ballType == ballType {
            i -= 1
            vertLength += 1
        }
        
        // Up
        i = row + 1
        while i < NumRows && balls[column, i]?.ballType == ballType {
            i += 1
            vertLength += 1
        }
        return vertLength >= 3
    }

    
    private func detectHorizontalMatches() -> Set<Chain> {
        // 1
        var set = Set<Chain>()
        // 2
        for row in 0..<NumRows {
            var column = 0
            while column < NumColumns-2 {
                // 3
                if let ball = balls[column, row] {
                    let matchType = ball.ballType
                    // 4
                    if balls[column + 1, row]?.ballType == matchType &&
                        balls[column + 2, row]?.ballType == matchType {
                        // 5: there's a chain of at least 3 balls
                        let chain = Chain(chainType: .horizontal)
                        repeat {
                            chain.add(ball: balls[column, row]!)
                            column += 1
                        } while column < NumColumns && balls[column, row]?.ballType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                // 6
                column += 1
            }
        }
        return set
    }
    
    
    
    private func detectVerticalMatches() -> Set<Chain> {
        var set = Set<Chain>()
        
        for column in 0..<NumColumns {
            var row = 0
            while row < NumRows-2 {
                if let ball = balls[column, row] {
                    let matchType = ball.ballType
                    
                    if balls[column, row + 1]?.ballType == matchType &&
                        balls[column, row + 2]?.ballType == matchType {
                        let chain = Chain(chainType: .vertical)
                        repeat {
                            chain.add(ball: balls[column, row]!)
                            row += 1
                        } while row < NumRows && balls[column, row]?.ballType == matchType
                        
                        set.insert(chain)
                        continue
                    }
                }
                row += 1
            }
        }
        return set
    }
    
    func removeMatches() -> Set<Chain> {
        let horizontalChains = detectHorizontalMatches()
        let verticalChains = detectVerticalMatches()
        
        removeBalls(chains: horizontalChains)
        removeBalls(chains: verticalChains)
        
        return horizontalChains.union(verticalChains)
    }
    
    private func removeBalls(chains: Set<Chain>) {
        for chain in chains {
            for ball in chain.balls {
                balls[ball.column, ball.row] = nil
            }
        }
    }*/



