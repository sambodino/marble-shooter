//
//  GameScene.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation
import UIKit
import FirebaseDatabase


/* TODO:
 create game states,
 boolean for ball being shot,
 create queue for random balls
 Change the points and positions to fit frame
 ASK PROFESSOR ABOUT BODY COLLISION
*/

/*NOTES
 Offset for Y position increment = 51
 
 
 */

var tapQueue = [Int]()

let RedBallCategoryName = "redBall"
let GreenBallCategoryName = "greenBall"
let YellowBallCategoryName = "yellowBall"
let OrangeBallCategoryName = "orangeBall"
let BlueBallCategoryName = "blueBall"
let CyanBallCategoryName = "tealBall"
let PurpleBallCategoryName = "purpleBall"
let CannonCategoryName = "cannon"
let GameMessageCategoryName = "gameMessage"
let ScoreLabelCategoryName = "label"
let PauseButtonCategoryName = "pauseButton"

let ShootingCatagoryName = "shootingMarble"
let StasisCatagoryName = "stasisMarble"

var marbleCounter = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    var viewController : UIViewController!
    var soundEffect: AVAudioPlayer!
   // var viewController : UIViewController!
    
    //might need to delete this.
    fileprivate var balls = Matrix<Ball>(rows: NumRows, columns: NumColumns)
    
    var level: Level!
    var game: GameViewController!
    
    var scoreLabel: SKLabelNode!

    var ballToBeShot: Ball!
    let shootingPosition = CGPoint(x: 0.0, y: -440.0)
    
    let TileWidth: CGFloat = 37.0
    let TileHeight: CGFloat = 40.0
    
    var ballCount: Int = 0
    var playerScore: Int = 0
    
    var gameOver : Bool = false
    var shotHasBeenHandled : Bool = false
    
    let gameLayer = SKNode()
    let ballsLayer = SKNode()
    
    let offsets = [-1, 0, 1]
    
    var chain = [Ball]() //these are the balls of the same color that need to be disappeared.
    

    
    
    
//Jons Code
    
    //Contact  CategoryMasks
    let ShootingBallCategory: UInt32 = 0x1 << 0
    let StasisCategory      : UInt32 = 0x1 << 1
    let FallingCategory     : UInt32 = 0x1 << 2
    let HoleBottomCategory  : UInt32 = 0x1 << 3
    let BottomCategory      : UInt32 = 0x1 << 4
    let CeilingCategory     : UInt32 = 0x1 << 5
    
    let marbleWidth = SKSpriteNode(imageNamed: "redBall").size.width
    let bodyWidth = SKSpriteNode(imageNamed: "redBall").size.width - 12
    
    let yOffset = CGFloat(51.0)
    let xOffset = CGFloat(30.0)
     
    let marbleCatagoryNameList = [RedBallCategoryName,GreenBallCategoryName, YellowBallCategoryName,
     OrangeBallCategoryName, BlueBallCategoryName, CyanBallCategoryName, PurpleBallCategoryName]
     
    var gamePaused = false
    var readyToShoot = true
 
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        //print("FRAME MAX X = \(frame.maxY)")
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        //ball.physicsBody!.contactTestBitMask = BottomCategory
        
        /*let pause = SKSpriteNode(imageNamed: "pauseButton")
        pause.position = CGPoint(x: -270, y: -520.0)
        pause.size = CGSize(width: 45.0, height: 45.0)
        pause.zPosition = 100
        addChild(pause)*/
        
        //add the score label
        scoreLabel = SKLabelNode(fontNamed: "Avenir Next Medium")
        scoreLabel.text = "\(playerScore)"
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.position = CGPoint(x: 265, y: -540)
        addChild(scoreLabel)
        
        //addChild(shootingMarble)
        
        let leftRect = CGRect(x: -345, y: -613.5, width: 1, height: 1227)
        let left = SKNode()
        left.physicsBody = SKPhysicsBody(edgeLoopFrom: leftRect)
        addChild(left)

        spawnMarbles()
        newGameClassic()
        
        
    }
    
    func newGameClassic(){
        newShootingMarble()
    }
    
    func calculateScore(){
        playerScore = playerScore + 60 * (chain.count - 2) //60 points for 3 in a row and then another 60 points for every ball after 3. (4 ball chain = 120 pts)
        self.updateLabels()
    }
    
    func updateLabels() {
        if playerScore != nil {
            scoreLabel.text = "\(playerScore)"
        }
    }
    
    func spawnMarbles(){
        let numberOfMarbles = NumRows * NumColumns
        
        //Should change this to fit the frame
        let spawnStartPosition: CGPoint = CGPoint(x: frame.minX + marbleWidth/2, y: frame.maxY - marbleWidth/2)
        let startPositionX = spawnStartPosition.x//CGFloat(-315.0)
        let startPositionY = spawnStartPosition.y//CGFloat(583.5)
        //var row = -1
        var offset: Bool
        var i = -1
        //NumRow and NumColumns come from Level.swift
        for row in 0..<7 {
            for column in 0..<NumColumns {
                i += 1
                //let rand = getRandomNumber(number: 7)
                var ballType = BallType.random()
                if(row % 2 == 0){
                    offset = false
                }
                else {
                    offset = true
                }
                let ball = Ball( row: row, column: column, offset: offset, ballType: ballType, position: pointFor(row: row, col: column))
                ball.sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)
                let marble = ball.sprite
                //Back here
                balls[row, column] = ball
                //let marble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
                marble?.position = pointFor(row: ball.row, col: ball.column)
                
               // //print("NEW TEST Grid Position(row,col) = \(gridFor(point:(marble?.position)!, offset: ball.offset ))")
                
                //ball.position = (marble?.position)!
                marble?.physicsBody = SKPhysicsBody(circleOfRadius: bodyWidth/2)
                marble?.physicsBody!.allowsRotation = false
                marble?.physicsBody!.friction = 0.0
                marble?.physicsBody!.affectedByGravity = true
                marble?.physicsBody!.isDynamic = false
                marble?.name = StasisCatagoryName
                marble?.physicsBody!.categoryBitMask = StasisCategory
                marble?.physicsBody!.contactTestBitMask = ShootingBallCategory
                marble?.zPosition = 2
                addChild(marble!)
                
            }
        }
        ////print("Grid: \(balls)")
        ////print("Ball[1,1] offset = \(balls[0,1]?.offset)")
    }
    
    
    func spawnNewRow(newRowOffset : Bool){
        let numberOfMarbles = NumColumns
        var mod : CGFloat = 0
        if newRowOffset{
            mod = marbleWidth/2
        }
       // //print("new Row Offset : \(newRowOffset)\n mod : \(mod)")
        //Should change this to fit the frame
        var spawnStartPosition: CGPoint = CGPoint(x: frame.minX + marbleWidth/2 + mod, y: frame.maxY - marbleWidth/2)
        ////print("startPosition : \(spawnStartPosition)")
        //var row = -1
        //var i = -1
        //NumRow and NumColumns come from Level.swift
        for column in 0..<NumColumns {
            //let rand = getRandomNumber(number: 7)
            let ballPosition = spawnStartPosition
            var ballType = BallType.random()
            let ball = Ball( row: 0, column: column, offset: newRowOffset, ballType: ballType, position: ballPosition)
            ball.sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)
            let marble = ball.sprite
            //Back here
            balls[0, column] = ball
            //let marble = SKSpriteNode(imageNamed: marbleCatagoryNameList[rand] + ".png")
            marble?.position = ball.position//pointFor(row: ball.row, col: ball.column)
            
           // //print("NEW TEST Grid Position(row,col) = \(gridFor(point:(marble?.position)!, offset: ball.offset ))")
            marble?.physicsBody = SKPhysicsBody(circleOfRadius: bodyWidth/2)
            marble?.physicsBody!.allowsRotation = false
            marble?.physicsBody!.friction = 0.0
            marble?.physicsBody!.affectedByGravity = true
            marble?.physicsBody!.isDynamic = false
            marble?.name = StasisCatagoryName
            marble?.physicsBody!.categoryBitMask = StasisCategory
            marble?.physicsBody!.contactTestBitMask = ShootingBallCategory
            marble?.zPosition = 2
            addChild(marble!)
            
            spawnStartPosition.x = spawnStartPosition.x + (marbleWidth)
            
        }
        ////print("Grid: \(balls)")
       // //////print("Ball[1,1] offset = \(balls[0,1]?.offset)")
    }
    
    func newShootingMarble(){
        let rand = getRandomNumber(number: 7)
        var ballType = BallType.random()
        let ball = Ball(row: 0, column: 0, offset: true, ballType: ballType, position: shootingPosition)
        ball.sprite = SKSpriteNode(imageNamed: ball.ballType.spriteName)//imageNamed: marbleCatagoryNameList[rand] + ".png")
        let shootingMarble = ball.sprite
        shootingMarble?.position = shootingPosition
        ////print("Marble Texture = \(shootingMarble?.texture)")
        shootingMarble?.physicsBody = SKPhysicsBody(circleOfRadius: bodyWidth/2, center: (shootingMarble?.position)!)
        //        shootingMarble.physicsBody!.contactTestBitMask = StasisCategory
        //        shootingMarble.physicsBody!.contactTestBitMask = CeilingCategory
        
        shootingMarble?.zPosition = 2
        
        shootingMarble?.physicsBody!.categoryBitMask = ShootingBallCategory
        
        
        shootingMarble?.physicsBody!.allowsRotation = false
        shootingMarble?.physicsBody!.friction = 0.0
        shootingMarble?.physicsBody!.affectedByGravity = true
        shootingMarble?.physicsBody!.isDynamic = false
        shootingMarble?.name = ShootingCatagoryName//marbleCatagoryNameList[rand]
        shootingMarble?.physicsBody!.categoryBitMask = ShootingBallCategory
        shootingMarble?.zPosition = 2
        //shootingMarble.physicsBody!.applyForce(CGVector(dx: 0.0, dy: 10.0))
        addChild((shootingMarble)!)
        readyToShoot = true
        shotHasBeenHandled = false
        self.view?.isUserInteractionEnabled = true
        
    }
    
    func shootMarble(atPoint pos : CGPoint){
        self.view?.isUserInteractionEnabled = false
        if readyToShoot {
            if let shootingMarble = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
                //shootingMarble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2, center: shootingMarble.position) this one is incorrect
                shootingMarble.physicsBody = SKPhysicsBody(circleOfRadius: bodyWidth/2)
                shootingMarble.physicsBody!.categoryBitMask = ShootingBallCategory
                shootingMarble.physicsBody!.friction = 0
                shootingMarble.physicsBody!.restitution = 1
                shootingMarble.physicsBody!.linearDamping = 0
                shootingMarble.physicsBody!.angularDamping = 0
                shootingMarble.physicsBody!.usesPreciseCollisionDetection = true
                let x = (pos.x)
                let y = (pos.y) - shootingPosition.y
                let hypotenus = sqrt(x*x + y*y)
                //Default Speed 150.0
                let xVector = (x/hypotenus)*80.0
                let yVector = (y/hypotenus)*80.0
                if yVector > 0 {
                    shootingMarble.physicsBody!.applyImpulse(CGVector(dx: xVector, dy: yVector))
                    readyToShoot = false
                    marbleCounter += 1
                }
            }
            
            if(UserDefaults.standard.bool(forKey: "switchState")){
                playSound()
            }
            
        }
        else {
            if let node = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
                ////print("balls: \(balls)")
                node.removeFromParent()
            }
            //shiftDown function
            ////print("Marble Counter : \(marbleCounter)")
            if (marbleCounter >= 4){
                shiftDown()
                marbleCounter = 0
            }
            newShootingMarble()
        }
        
    }
    
    
    func stopMusic(){
        let path = Bundle.main.path(forResource: "sounds/background.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            soundEffect = sound
            sound.stop()
        }catch {
            // couldn't load file :(
        }
    }
    
    func playSound(){
        let path = Bundle.main.path(forResource: "cannon.wav", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            soundEffect = sound
            sound.play()
        }catch {
            // couldn't load file :(
        }

    }
    
    func freezeShootingMarble(freezePosition: CGPoint){
        
        if var marble = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
            //            let newStasisMarble = childNode(withName: StasisCatagoryName) as! SKSpriteNode
            //            newStasisMarble.texture = shootingMarble.texture
            //            newStasisMarble.physicsBody = SKPhysicsBody(circleOfRadius: marbleWidth/2)
            var holdPosition = freezePosition //position of the marble hit by the shooting marble
            holdPosition.x = freezePosition.x.rounded()
            holdPosition.y = (10*freezePosition.y).rounded()/10
            
            ////print("NEW TEST Freezing Position: \(freezePosition)")
            ////print("Hold Position: \(holdPosition)")
            
            let newPosition : CGPoint = fitMarbleToGrid(contactPoint: marble.position, offset: calculateIfOffset(xPos: holdPosition.x), yPosCheck: holdPosition.y)
            //
            
            ////print("Shooting Marble Position = \(marble.position)")
            marble.position = newPosition
            ////print("New Position = \(marble.position)")
            
            //Use newPosition to figure out row and column
            let rowCol = gridFor(point: marble.position, offset: calculateIfOffset(xPos: marble.position.x))
            ////print("NEW TEST ROWCOL = \(rowCol)")
            //Use tuple to add new ball to matrix
            ////print("Marble description: \(marble.description)")
            ////print("QUARK marble texture: \(marble.texture)")
            let ballType = BallType.color(color: getBallTypeFromTexture(texture: marble.texture!))
            print(rowCol)
            if(rowCol.row > 18){
                gameOver = true
                gameOverAlert()
            }
            
            //BACK HERE
            let newBall = Ball(row: rowCol.row, column: rowCol.column, offset: calculateIfOffset(xPos: marble.position.x), ballType: ballType, position: marble.position)
            newBall.sprite = SKSpriteNode(imageNamed: newBall.ballType.spriteName)
            
            balls[rowCol.row, rowCol.column] = newBall           ////print("QUARK new ball position \(balls[rowCol.row, rowCol.column]?.position.x)")
            //print("NEW TEST FROZEN Position(row,col) = \(gridFor(point: marble.position, offset: calculateIfOffset(xPos: marble.position.x) ))")
            //print("Grid Ball at \(rowCol.row),\(rowCol.column): \(balls[rowCol.row,rowCol.column]?.offset)")
            
            //change marble to be sprite
            marble = newBall.sprite!
            marble.position = newPosition
            marble.physicsBody = SKPhysicsBody(circleOfRadius: bodyWidth/2)
            marble.physicsBody!.allowsRotation = false
            marble.physicsBody!.friction = 0.0
            marble.physicsBody!.affectedByGravity = true
            marble.physicsBody!.isDynamic = false
            
            marble.name = StasisCatagoryName
            marble.physicsBody!.categoryBitMask = StasisCategory
            marble.physicsBody!.contactTestBitMask = ShootingBallCategory
            addChild(marble)
            //Depth first search of marbles to delete
            doDFS(matrix: balls, row: rowCol.row, col: rowCol.column, ball: balls[rowCol.row, rowCol.column]!, count: 0)
            
            if let node = childNode(withName: ShootingCatagoryName) as! SKSpriteNode?{
                //print("balls: \(balls)")
                node.removeFromParent()
            }
            //if chain is long enough, destroy all marbles in chain
            deleteChain()
            //reset searched bools
            setBallsSearchedFalse()
            self.view?.isUserInteractionEnabled = true
            
        }
        
        shotHasBeenHandled = true
    }
    
    func deleteChain(){
        //print("CHAIN LENGTH : \(chain.count)")
        //print("CHAIN LAST INDEX : \(chain.endIndex)")
        if chain.endIndex > 2 {
            calculateScore()
            for ball in chain{
                //game?.calculateScore(chain: chain)
                let breakingMarbles = nodes(at: ball.position)
                for marble in breakingMarbles{
                    marble.removeFromParent()
                    //print("CHAIN NODE REMOVED")
                }
                balls[ball.row, ball.column] = nil
                //print("New test: Ball at \(ball.row, ball.column) = \(balls[ball.row, ball.column])")
            }
        }
        chain.removeAll()
    }
    
    func neighborExists(matrix: Matrix<Ball>, row: Int, col: Int, ballType: BallType) -> Bool {
        
        
        
        if( (row >= 0) && (row < balls.rows) && (col >= 0) && (col < balls.columns) ){
            
            //check the color of the ball and compare it
            
            if( balls[row, col]?.ballType == ballType && balls[row, col]?.alreadySearched == false ){
                //print("NEW CHAIN IN FUNC: \(chain)")
                return true
                
            }
            
        }
        
        return false
        
        
        
    }
    
    
    
    //check chains length then loop through if larger than 2 and delete all Balls in matrix that are in the chain.
    
    func doDFS(matrix: Matrix<Ball>, row: Int, col: Int, ball: Ball, count : Int){
        var count = count + 1
        let offset = ball.offset
        var mod = 0
        if !offset { //if the ball being searched around is not in an offset row
            mod = -1
        }
        balls[row,col]?.alreadySearched = true
        //print("CHAIN Count = \(count)")
        chain.append((balls[row,col]!))
        //check left
        if (col != 0){
            if (neighborExists(matrix: matrix, row: row, col: col-1, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursively search it
                if((balls[row, col-1]?.alreadySearched)! == false){
                    balls[row, col-1]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row, col: col - 1, ball: balls[row,col - 1]!, count: count)
                }
            }
        }
        //check right
        if (col != 10){
            if (neighborExists(matrix: matrix, row: row, col: col+1, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursively search it
                if((balls[row, col+1]?.alreadySearched)! == false){
                    balls[row, col+1]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row, col: col + 1, ball: balls[row,col + 1]!, count: count)
                }
            }
        }
        
        //check row up
        if (row != 0){
            if (neighborExists(matrix: matrix, row: row-1, col: col + mod, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursively search it
                if((balls[row-1, col + mod]?.alreadySearched)! == false){
                    balls[row-1, col + mod]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row-1, col: col + mod, ball: balls[row-1,col+mod]!, count: count)
                    //matrix[row, col+1]?.toBeDestroyed = true
                }
            }
            
            if (neighborExists(matrix: matrix, row: row-1, col: col + 1 + mod, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursively search it
                if( balls[row-1, col+1+mod] != nil && ((balls[row-1, col+1+mod]?.alreadySearched)! == false)){
                    balls[row-1, col+1+mod]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row-1, col: col + 1 + mod, ball: balls[row-1,col+1+mod]!, count: count)
                    //matrix[row, col+1]?.toBeDestroyed = true
                }
            }
        
        }
        //check row down
        if (row != 20){
            if (neighborExists(matrix: matrix, row: row+1, col: col + mod, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursive ly search it
                if((balls[row+1, col + mod]?.alreadySearched)! == false){
                    balls[row+1, col + mod]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row+1, col: col + mod, ball: balls[row+1,col+mod]!, count: count)
                    //matrix[row, col+1]?.toBeDestroyed = true
                }
            }
            
            if (neighborExists(matrix: matrix, row: row+1, col: col + 1 + mod, ballType: ball.ballType)){
                //if neighbor toBeDestroyed = false, set to true and recursively search it
                if((balls[row+1, col+1+mod]?.alreadySearched)! == false){
                    balls[row+1, col+1+mod]?.alreadySearched = true
                    //count += 1
                    doDFS(matrix: matrix, row: row+1, col: col + 1 + mod, ball: balls[row+1,col+1+mod]!, count: count)
                    //matrix[row, col+1]?.toBeDestroyed = true
                }
            }
        }
        
    }
    
    //resets all the ballSearched bools to false so that they can 
    //be searched again
    func setBallsSearchedFalse(){
        for row in 0..<balls.rows{
            for col in 0..<balls.columns{
                if(balls[row,col] != nil){
                    balls[row,col]?.alreadySearched = false
                }
            }
        }
    }
    
    func calculateIfOffset(xPos: CGFloat) -> Bool{
        let x = Int(xPos) + 345
        //print("Quark xPosition : \(x)")
        if (x % Int(marbleWidth) == 0){
            return true
        }
        return false
    }
    
    func pointFor(row: Int, col:Int) ->CGPoint {
        if (row % 2 == 0){
            return CGPoint(x: -315.0 + (60 * CGFloat(col)), y: 583.5 - (51 * CGFloat(row)))
        }
        return CGPoint(x: -285.0 + (60 * CGFloat(col)), y: 583.5 - (51 * CGFloat(row)))
    }
    //returns a tupple containing grid location for a given point
    func gridFor(point: CGPoint, offset: Bool) -> (row: Int, column: Int){
        var column = point.x.rounded()
        var row = point.y.rounded()
        if(offset){
            column = column + 315
            column = column/xOffset
        }
        else{
            column = column + 345
            column = column/xOffset
        }
        row = row - 613.5
        row = -(row/yOffset)
        
        //not sure why but this gives back correct column
        column = column - 1
        column = column / 2
        //column = column - 1
        
        return (Int(row), Int(column))
    }
    
    //pretty self explanitory
    func getBallTypeFromTexture(texture: SKTexture) -> Int{
        let string = texture.description
        if string.range(of:"blueBall") != nil{
            return 1
        }
        if string.range(of:"greenBall") != nil{
            return 2
        }
        if string.range(of:"orangeBall") != nil{
            return 3
        }
        if string.range(of:"purpleBall") != nil{
            return 4
        }
        if string.range(of:"redBall") != nil{
            return 5
        }
        if string.range(of:"tealBall") != nil{
            return 6
        }
        if string.range(of:"yellowBall") != nil{
            return 7
        }
        return 0
    }
    
    func fitMarbleToGrid(contactPoint: CGPoint, offset: Bool, yPosCheck: CGFloat) -> CGPoint {

        var newPosition : CGPoint = contactPoint
        var thisOffset : Bool = true
        //makes the math easier
        var yPos = contactPoint.y - frame.maxY
        var xPos = contactPoint.x + frame.maxX
        ////print("fitMarbleToGrid yPosition before = \(yPos)")
        //print("fitMarbleToGrid: Y POSITION 1 : \(yPos)")
        //calculate closest yPos
        yPos = (floor((yPos)/yOffset)+1)*yOffset - marbleWidth/2
        ////print("fitMarbleToGrid yPosition after = \(yPos)")
        
        //print("fitMarbleToGrid: Y POSITION 2 : \(yPos)")

        yPos += frame.maxY
        //convert back
        //check to make sure its not a row off
        if(abs(yPos - yPosCheck) > yOffset){
            yPos += yOffset
        }
        newPosition.y = yPos
        //print("fitMarbleToGrid: X POSITION 1 : \(xPos)")
        xPos = ((xPos)/marbleWidth).rounded()*marbleWidth //- marbleWidth/2
        
        if ((yPos == contactPoint.y)){
            if (offset){
                xPos = xPos + xOffset
                //print("FitMarbleToGrid Offsetting 1")
                thisOffset = false
            }
        }
        else{
            if(!offset){
                xPos = xPos + xOffset
                //print("fitMarbleToGrid Offsetting 2")
                thisOffset = false
            }
        }
        //print("fitMarbleToGrid: X POSITION 3 : \(xPos)")
        //vvv this if checks to see if the marble is already in position
        if(!((xPos.remainder(dividingBy: marbleWidth) == 0 && !thisOffset)||(thisOffset && (xPos + xOffset).remainder(dividingBy: marbleWidth) == 0))){
            if ((0 < (xPos.remainder(dividingBy: marbleWidth)) && (xPos.remainder(dividingBy: marbleWidth)) < 30) && (abs(contactPoint.x + frame.maxX - xPos) < 30)){
                //print("fitMarbleToGrid: \((xPos.remainder(dividingBy: marbleWidth)))")
                //print("fitMarbleToGrid: \((abs(contactPoint.x + frame.maxX - xPos)))")
                xPos -= xOffset
            }
            else {
                xPos += xOffset

            }
            //print("fitMarbleToGrid: X POSITION 4 : \(xPos)")
            //print("fitMarbleToGrid: contact POSITION : \(contactPoint.x + frame.maxX)")
            
            if((contactPoint.x + frame.maxX) - xPos > 30){//if shift left > 30 points
                xPos += 60
            }
            if(xPos - (contactPoint.x + frame.maxX) > 30){//if shift right > 30 points
                xPos -= 60
            }
        }
        if(xPos < 30){//dont let it go out of bounds
            xPos = 30
        }
        if(xPos > 660){
            xPos = 660
        }
        //print("fitMarbleToGrid: X POSITION 5 : \(xPos)")

        ////print("xPosition after = \(xPos.remainder(dividingBy: marbleWidth))")
        
        if(checkGridForNill(point: newPosition)){
            //TODO: Do something here I guess
            if(newPosition.x < 315){
                newPosition.x += 60
            }
        }
        //print("fitMarbleToGrid: X POSITION 6 : \(xPos)")
        
        xPos -= frame.maxX
        newPosition.x = xPos
        ////print("fitMarbleToGrid: X POSITION 7 : \(xPos-frame.maxX)")
        //print("fitMarbleToGrid newPosition : \(newPosition)")
        return newPosition
        
    }
    
    func checkGridForNill(point : CGPoint) -> Bool{
        let offset = calculateIfOffset(xPos: point.x)
        let rowCol = gridFor(point: point, offset: offset )
        if(balls[rowCol.row,rowCol.column] == nil){
            return true
        }
        return false
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
    //TODO: Work on this function
    func shiftDown(){
        //print("grid(8,0) = \(balls[8,0])")
        var newRowOffset : Bool?
        for col in 0...19{
            if(balls[0,col] != nil){
                newRowOffset = (balls[0,col]?.offset)!
            }
        }
        for row in stride(from: 19, through: 0, by: -1) {
            for col in stride(from: 10, through: 0, by: -1){
                if(balls[row,col] != nil){
                    let startPos = balls[row,col]?.sprite?.position.y
                    balls[row,col]?.row += 1
                    balls[row,col]?.position.y -= yOffset
                    balls[row,col]?.sprite?.position.y = (balls[row,col]?.position.y)!
                    //print("MLKJ: row \(row)\(balls[row,col]?.sprite?.position.y)")
                    
                    balls[row+1,col] = balls[row,col]
                    if(startPos! - (balls[row+1, col]?.sprite?.position.y)! > 51){
                        //print("SHIFT DOWN PROBLEM AT BALL : \(balls[row+1,col])")
                    }
                }
            }
        }
        //print("NEW ROW OFFSET : \(newRowOffset!)")
        spawnNewRow(newRowOffset: newRowOffset!)
        if(checkRow20()){
            gameOver = true
            gameOverAlert()
            //showPauseAlert()
        }
    }
    
    func checkRow20() -> Bool{
        print("CHECKING ROWS")
        for col in 0...10{
            if (balls[18,col] != nil){
                print("GAME OVER")
                return true
            }
        }
        return false
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (!shotHasBeenHandled) {//if shot has not been handled
            //print("didBegin")
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
            if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == BottomCategory {
                //print("Hit ceiling. First contact has been made.")
            }
            if firstBody.categoryBitMask == ShootingBallCategory && secondBody.categoryBitMask == StasisCategory {
                ////print("Hit marble secondBody \(secondBody.node!.position)")
                ////print("Hit marble firstBody \(firstBody.node!.position)")
                
                //TODO: Figure out how to pick one when two hit at the same time
                freezeShootingMarble(freezePosition: secondBody.node!.position)
                
            }
            else {
                //print("first body: \(firstBody)")
                //print("secondBody : \(secondBody)")
            }
        }
    }
    
    
    
    func getRandomNumber(number: UInt32) -> Int{
        let rand = Int(arc4random_uniform(number))
        return rand
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
        //TODO: Structure of this app is fucked, so this is how we do it
        shootMarble(atPoint: pos)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            self.touchUp(atPoint: t.location(in: self))
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
}

private extension GameScene {
    func gameOverAlert(){
        let alert = UIAlertController(title: "Game Over", message: "add a username", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        let textField = alert.textFields![0]
                                        
                                        let ref = FIRDatabase.database().reference(fromURL: "https://marble-shooter.firebaseio.com/")
                                        let scoresRef = ref.child("scores").childByAutoId()
                                        scoresRef.updateChildValues(["scoreVal": Int(self.scoreLabel.text!)!, "username": textField.text!])
                                        
                                        let view = self.view 
                                        let scene = SKScene(fileNamed: "GameScene")
                                            // Set the scale mode to scale to fit the window
                                            scene?.scaleMode = .aspectFill
                                            
                                            let transition = SKTransition.fade(withDuration: 1)
                                            // Present the scene
                                            view?.presentScene(scene!, transition: transition)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default){ action in
            
            let view = self.view as! SKView?
            let scene = SKScene(fileNamed: "GameScene")
            // Set the scale mode to scale to fit the window
            scene?.scaleMode = .aspectFill
            
            let transition = SKTransition.fade(withDuration: 1)
            // Present the scene
            view?.presentScene(scene!, transition: transition)
        }
        
        alert.addTextField()
    
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}

