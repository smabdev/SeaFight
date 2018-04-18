//
//  StartViewController.swift
//  SeaFight
//
//  Created by Алех on 26.01.18.
//  Copyright © 2018 Алех. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {

    @IBOutlet weak var OKButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OKButton.layer.cornerRadius = OKButton.frame.height/2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
