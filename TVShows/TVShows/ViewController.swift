//
//  ViewController.swift
//  TVShows
//
//  Created by Infinum on 04/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.red
    }

    @IBAction func switchChanged(_ sender: Any) {
    }
    @IBAction func MyAction(_ sender: UISwitch){
        let color: UIColor = sender.isOn ? .red : .yellow
        view.backgroundColor = color
    }
    
}

