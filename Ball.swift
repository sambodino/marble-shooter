//
//  Ball.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/9/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import SpriteKit

enum BallType: Int, CustomStringConvertible {
    case unknown = 0, green, blue, yellow, orange, red, teal, purple
    
    var description: String {
        return spriteName
    }
    
    var spriteName: String {
        let spriteNames = [
            "blueBall",
            "greenBall",
            "orangeBall",
            "purpleBall",
            "redBall",
            "tealBall",
            "yellowBall"
        ]
        
        return spriteNames[rawValue - 1] //arrays index start with 0
    }
    
    var highlightedSpriteName: String {
        return spriteName + "-Highlighted"
    }
    
    static func random() -> BallType {
        return BallType(rawValue: Int(arc4random_uniform(7)) + 1)!
    }
    static func color(color : Int) -> BallType{
        return BallType(rawValue: color)!
    }

}

class Ball: CustomStringConvertible, Hashable{
    var column: Int
    var row: Int
    var offset: Bool
    var alreadySearched: Bool
    var position: CGPoint
    let ballType: BallType
    var sprite: SKSpriteNode?
    
    //Hashable protocol requires a hash value
    var hashValue: Int {
        return row*10 + column
    }
    
    var description: String {
        return "type:\(ballType) grid:(\(row),\(column)) position:\(position) "
    }
    
    init(row: Int, column: Int, offset: Bool, ballType: BallType, position: CGPoint) {
        self.column = column
        self.row = row
        self.offset = offset
        self.ballType = ballType
        self.position = position
        self.alreadySearched = false
    }
}
//for comparing two objects of the same type required by Hashable protocol
func ==(lhs: Ball, rhs: Ball) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
