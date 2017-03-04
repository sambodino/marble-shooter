//
//  GameViewController.swift
//  iOSProject2016
//
//  Created by Jonathan Light on 10/25/16.
//  Copyright © 2016 Jonathan Light. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var level: Level!
    var soundEffect: AVAudioPlayer!
    
    lazy var backgroundMusic: AVAudioPlayer? = {
        guard let url = Bundle.main.url(forResource: "background.mp3", withExtension: nil) else {
            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            return player
        } catch {
            return nil
        }
    }()
    
    /*func playMusic(){
        let path = Bundle.main.path(forResource: "background.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOf: url)
            soundEffect = sound
            sound.play()
        }catch {
            // couldn't load file :(
        }
        
    }*/
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if(UserDefaults.standard.bool(forKey: "switchState2")){
          backgroundMusic?.play()
        }
        

        //JONS CODE
        if let view = self.view as! SKView? {
            
            
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                let transition = SKTransition.fade(withDuration: 3)
                // Present the scene
                view.presentScene(scene, transition: transition)
                //scene.viewController = self
            }
        
            view.ignoresSiblingOrder = true
            //GOOD FOR VIEWING THE PHYZICZ
            view.showsPhysics = true
            view.showsFPS = true
            view.showsNodeCount = true
            
            //score = 0
            beginGame()
        }

    }
    
    func beginGame() {
       // score = 0
        //updateLabels()
        //shuffle()
    }
    
    func shuffle() {
        //let newBalls = level.shuffle()
       // scene.addSprites(for: newBalls)
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        backgroundMusic?.stop()
        super.viewWillDisappear(animated)
    }

    
    
}
