//
//  GameScene.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import SpriteKit
import GameplayKit

/* TODO:
 create game states, 
 boolean for ball being shot,
 create queue for random balls
 
 
 */

/*NOTES
 Offset for Y position increment = 51
 
 
 */

let RedBallCategoryName = "redBall"
let GreenBallCategoryName = "greenBall"
let YellowBallCategoryName = "yellowBall"
let OrangeBallCategoryName = "orangeBall"
let BlueBallCategoryName = "blueBall"
let CyanBallCategoryName = "tealBall"
let PurpleBallCategoryName = "purpleBall"
let CannonCategoryName = "cannon"
let GameMessageName = "gameMessage"
let ScoreLabelName = "label"
let ShootingCatagoryName = "shootingMarble"

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    //CategoryMasks
    let ShootingBallCategory: UInt32 = 0x1 << 0
    let StasisCategory      : UInt32 = 0x1 << 1
    let FallingCategory     : UInt32 = 0x1 << 2
    let HoleBottomCategory  : UInt32 = 0x1 << 3
    let BottomCategory      : UInt32 = 0x1 << 4
    let CeilingCategory     : UInt32 = 0x1 << 5
    
    let shootingPosition = CGPoint(x: 0.0, y: -440.0)
    
    let marbleWidth = SKSpriteNode(imageNamed: "redBall").size.width
    
    let yOffset = CGFloat(51.0)
    let xOffset = CGFloat(30.0)
    
    let marbleCatagoryNameList = [RedBallCategoryName,GreenBallCategoryName, YellowBallCategoryName,
                                  OrangeBallCategoryName, BlueBallCategoryName, CyanBallCategoryName, PurpleBallCategoryName]
    
    var gamePaused = false
    
    override func didMove(to view: SKView) {
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
        //ball.physicsBody!.contactTestBitMask = BottomCategory
        
        
        
        //addChild(shootingMarble)
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 1)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        let ceilingRect = CGRect(x: -375.0, y: 664.0, width: frame.size.width, height: 1)
        let ceiling = SKNode()
        ceiling.physicsBody = SKPhysicsBody(edgeLoopFrom: ceilingRect)
        addChild(ceiling)
        
        bottom.physicsBody!.categoryBitMask = BottomCategory
        ceiling.physicsBody!.categoryBitMask = CeilingCategory
        
        newShootingMarble()

        spawnMarbles()

        
    }
    
    func newShootingMarble(){
        
        let rand = getRandomNumber(number: 7)
        
        let shootingMarble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
        shootingMarble.position = shootingPosition
        shootingMarble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2, center: shootingMarble.position)
//        shootingMarble.physicsBody!.contactTestBitMask = StasisCategory
//        shootingMarble.physicsBody!.contactTestBitMask = CeilingCategory
        
        shootingMarble.zPosition = 2
        
        shootingMarble.physicsBody!.categoryBitMask = ShootingBallCategory
        
        
        shootingMarble.physicsBody!.allowsRotation = false
        shootingMarble.physicsBody!.friction = 0.0
        shootingMarble.physicsBody!.affectedByGravity = true
        shootingMarble.physicsBody!.isDynamic = false
        shootingMarble.name = ShootingCatagoryName//marbleCatagoryNameList[rand]
        shootingMarble.physicsBody!.categoryBitMask = StasisCategory
        shootingMarble.zPosition = 2
        addChild(shootingMarble)

    }
    
    
    func touchDown(atPoint pos : CGPoint) {
//                if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//                    n.position = pos
//                    n.strokeColor = SKColor.green
//                    self.addChild(n)
//                }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        //        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
        //            n.position = pos
        //            n.strokeColor = SKColor.blue
        //            self.addChild(n)
        //        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        //this creates a new node and we dont want that. we want to use the existing shootingMarbleNode
        
        if let shootingMarble = childNode(withName: ShootingCatagoryName) as! SKSpriteNode? {
            let x = (pos.x)
            let y = (pos.y) - shootingPosition.y
            let hypotenus = sqrt(x*x + y*y)
            let xVector = (x/hypotenus)*150.0
            let yVector = (y/hypotenus)*150.0
            shootingMarble.physicsBody!.applyImpulse(CGVector(dx: xVector, dy: yVector))
            print("Shooting Marble")
        }
        
        
        
    }
    
    func breakMarble(node: SKNode) {
        
        //if gameState.currentState is Playing {
            //self.score += 10
            //let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
            //particles.position = node.position
            //particles.zPosition = 3
            //addChild(particles)
            //particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                             //SKAction.removeFromParent()]))
        //}
        node.removeFromParent()
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        // 2
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        // 3
        if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == CeilingCategory {
            print("Hit ceiling. First contact has been made.")
        }
        if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == StasisCategory {
            print("Hit marble.")
            
        }
    }
    
    
    
    func getRandomNumber(number: UInt32) -> Int{
        let rand = Int(arc4random_uniform(number))
        return rand
    }
    
    func spawnMarbles(){
        let numberOfMarbles = 55
        let startPositionX = CGFloat(-315.0)
        let startPositionY = CGFloat(583.5)
        var row = -1
        
        
        for i in 0..<numberOfMarbles {
            if ((i)%11 == 0){
                row += 1
            }
            let rand = getRandomNumber(number: 7)
            let marble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
            if (row % 2 == 0) {
                marble.position = CGPoint(x: startPositionX + (marbleWidth * CGFloat(i%11)), y: startPositionY - yOffset*(CGFloat(row)))
            }
            else{
                marble.position = CGPoint(x: startPositionX + xOffset + (marbleWidth * CGFloat(i%11)), y: startPositionY - yOffset*(CGFloat(row)))
            }
            marble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2, center: marble.position)
            marble.physicsBody!.allowsRotation = false
            marble.physicsBody!.friction = 0.0
            marble.physicsBody!.affectedByGravity = false
            marble.physicsBody!.isDynamic = false
            marble.name = marbleCatagoryNameList[rand]
            marble.physicsBody!.categoryBitMask = StasisCategory
            marble.zPosition = 2
            addChild(marble)
            //print("Row = \(row)")
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        if let label = self.label {
        //            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        //        }
        //
        //        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
                  for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
