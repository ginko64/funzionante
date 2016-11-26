//
//  primoViewController.swift
//  funzionante
//
//  Created by Mario Regeni on 22/11/16.
//  Copyright © 2016 Mario Regeni. All rights reserved.
//

import UIKit
import AVFoundation

var AudioPlayer = AVAudioPlayer()

class primoViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let AssortedMusics = NSURL(fileURLWithPath: Bundle.main.path(forResource: "music", ofType: "mp3")!)
        AudioPlayer = try! AVAudioPlayer(contentsOf: AssortedMusics as URL)
        AudioPlayer.prepareToPlay()
        AudioPlayer.numberOfLoops = 0
        AudioPlayer.play()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
