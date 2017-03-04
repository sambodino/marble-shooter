//
//  SettingsViewController.swift
//  MarbleShooter
//
//  Created by Sam Knepper on 10/31/16.
//  Copyright © 2016 Apress. All rights reserved.
//

import UIKit

var status = UserDefaults().string(forKey: "status")
var status2 = UserDefaults().string(forKey: "status2")

class SettingsViewController: UIViewController {

    @IBOutlet weak var soundSwitch: UISwitch!
    @IBOutlet weak var musicSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let status = UserDefaults().string(forKey: "status")
        
        if status == "OFF" {
            soundSwitch.setOn(false, animated: false)
        }else{
            soundSwitch.setOn(true, animated: true)
        }
        
        soundSwitch.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        
        if status2 == "OFF" {
            musicSwitch.setOn(false, animated: false)
        }else{
            musicSwitch.setOn(true, animated: true)
        }
        
        musicSwitch.isOn =  UserDefaults.standard.bool(forKey: "switchState2")
        

    }
    
    @IBAction func musicSwitchPressed(_ sender: UISwitch) {
        if(musicSwitch.isOn){
            UserDefaults().set("ON", forKey: "status2")
        }else{
            UserDefaults().set("OFF", forKey: "status2")
            
        }
        UserDefaults.standard.set(musicSwitch.isOn, forKey: "switchState2")
    }
    
        // Do any additional setup after loading the view.
    @IBAction func soundSwitchPressed(_ sender: UISwitch) {
        if(soundSwitch.isOn){
            UserDefaults().set("ON", forKey: "status")
        }else{
            UserDefaults().set("OFF", forKey: "status")
        }
        UserDefaults.standard.set(soundSwitch.isOn, forKey: "switchState")
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
