//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 11/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var label: UILabel!
    
    //MARK: - Properties
    private var numberOfTaps: Int = 0
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Actions
    @IBAction private func buttonPressed(_ sender: Any) {
        numberOfTaps += 1
        label.text = String(numberOfTaps)
    }
}
