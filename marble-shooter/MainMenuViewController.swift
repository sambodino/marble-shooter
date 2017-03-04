//
//  MainMenuViewController.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 10/25/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import UIKit
import FirebaseDatabase

class MainMenuViewController: UIViewController {
    @IBOutlet weak var thePlayButton: UIButton!

    @IBAction func pressedAddScoreButton(_ sender: UIButton) {
        print("add score")
        
        let alert = UIAlertController(title: "Game Over",
                                      message: "add a username",
                                      preferredStyle: .alert)
        
        
        let saveAction = UIAlertAction(title: "Save",
                        style: .default) { action in
                                let textField = alert.textFields![0]
                        
                                let ref = FIRDatabase.database().reference(fromURL: "https://marble-shooter.firebaseio.com/")
                                let scoresRef = ref.child("scores").childByAutoId()
                                scoresRef.updateChildValues(["scoreVal": "0", "username": textField.text!])
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)

        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
