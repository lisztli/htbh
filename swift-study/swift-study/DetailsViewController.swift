//
//  DetailsViewController.swift
//  swift-study
//
//  Created by liszt on 2/1/15.
//  Copyright (c) 2015 Llhf. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var album: Album?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumCover: UIImageView!
    
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(
            data: NSData(
                contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
    }
}