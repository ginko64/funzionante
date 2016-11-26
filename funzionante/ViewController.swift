//
//  ViewController.swift
//  funzionante
//
//  Created by Mario Regeni on 22/11/16.
//  Copyright © 2016 Mario Regeni. All rights reserved.
//

import UIKit



class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let rate = RateMyApp.sharedInstance
        rate.appID = "1179386289"
        
        DispatchQueue.main.async(execute: { () -> Void in
            rate.trackAppUsage()
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func playSound(_ sender: UIButton) {
        
    }
    
}

