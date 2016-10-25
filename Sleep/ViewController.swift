//
//  ViewController.swift
//  Sleep
//
//  Created by Stephen Woodford on 10/25/16.
//  Copyright © 2016 Stephen Woodford. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sleepTimerButton: UIButton!
    
    let sleepTimerMinuteOptions = [15, 30, 45, 60, 90, 120]
    
    var sleepTimer: Timer? = nil
    var sleepTimerButtonUpdateTimer: Timer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sleepClick(_ sender: AnyObject) {
        
        let alert = UIAlertController(title: nil, message: "Setting the Sleep Timer will exit back to the Guide after the time has elapsed to allow your Apple TV's Sleep After setting to put your TV to sleep.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Off", style: .default, handler: { (action) in
            self.cancelSleepTime()
        }))
        
        for minuteOption in sleepTimerMinuteOptions {
            alert.addAction(UIAlertAction(title: "\(minuteOption) minutes", style: .default, handler: { (action) in
                self.setSleepTime(minuteOption)
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Back", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    func setSleepTime(_ minutes: Int) {
        let sleepSeconds = TimeInterval(minutes * 60)
        
        cancelSleepTime()
        
        sleepTimer = Timer.scheduledTimer(timeInterval: sleepSeconds, target: self, selector: #selector(sleepFire), userInfo: nil, repeats: false)
        
        sleepTimerButtonUpdateTimer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateSleepTimerButton), userInfo: nil, repeats: true)
        
        sleepTimerButton.setTitle("Sleep Timer: \(minutes) min", for: .normal)
    }
    
    func updateSleepTimerButton() {
        let remainingMinutes = Calendar.current.dateComponents([.minute], from: Date.init(), to: (sleepTimer?.fireDate)!).minute ?? 0
        
        sleepTimerButton.setTitle("Sleep Timer: \(remainingMinutes) min", for: .normal)
    }
    
    func sleepFire() {
        sleepTimerButtonUpdateTimer?.invalidate()
        sleepTimerButtonUpdateTimer = nil
        
        // Exit to Guide
    }
    
    func cancelSleepTime() {
        sleepTimerButton.setTitle("Sleep Timer: Off", for: .normal)
        
        if sleepTimer != nil {
            sleepTimer?.invalidate()
            sleepTimer = nil
        }
        
        if sleepTimerButtonUpdateTimer != nil {
            sleepTimerButtonUpdateTimer?.invalidate()
            sleepTimerButtonUpdateTimer = nil
        }
    }

}

