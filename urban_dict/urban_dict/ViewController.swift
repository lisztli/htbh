//
//  ViewController.swift
//  urban_dict
//
//  Created by liszt on 7/13/15.
//  Copyright (c) 2015 Llhf. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startCounter: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get the word_id from pc.plist
        let path = NSBundle.mainBundle().pathForResource("pc", ofType: "plist")
        let dict:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        let pc_dict:NSMutableDictionary = dict.objectForKey("pc")! as! NSMutableDictionary
        let word_id:NSNumber = pc_dict.objectForKey("word_id") as! NSNumber
        
        pc_dict.setValue(NSNumber(integer: word_id as Int + 1), forKey: "word_id")
        
        dict.writeToFile(path!, atomically: true)
        self.startCounter.text = "\(word_id)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

