//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 11/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet private weak var label: UILabel!
    
    private var numberOfTaps: Int = 0
    
    @IBAction private func buttonPressed(_ sender: Any) {
        numberOfTaps += 1
        label.text = String(numberOfTaps)
    }
}
