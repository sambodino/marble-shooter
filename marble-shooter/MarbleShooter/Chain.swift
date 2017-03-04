//
//  Chain.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/25/16.
//  Copyright © 2016 Apress. All rights reserved.
//

//
//  Chain.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 11/25/16.
//  Copyright © 2016 Apress. All rights reserved.
//

class Chain: Hashable, CustomStringConvertible {
    var balls = [Ball]()
    
    enum ChainType: CustomStringConvertible {
        case horizontal
        case vertical
        
        var description: String {
            switch self {
            case .horizontal: return "Horizontal"
            case .vertical: return "Vertical"
            }
        }
    }
    
    var chainType: ChainType
    
    init(chainType: ChainType) {
        self.chainType = chainType
    }
    
    func add(ball: Ball) {
        balls.append(ball)
    }
    
    func firstball() -> Ball {
        return balls[0]
    }
    
    func lastball() -> Ball {
        return balls[balls.count - 1]
    }
    
    var length: Int {
        return balls.count
    }
    
    var description: String {
        return "type:\(chainType) balls:\(balls)"
    }
    
    var hashValue: Int {
        return balls.reduce (0) { $0.hashValue ^ $1.hashValue }
    }
}

func ==(lhs: Chain, rhs: Chain) -> Bool {
    return lhs.balls == rhs.balls
}
