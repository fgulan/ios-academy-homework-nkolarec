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
    @IBOutlet private weak var button: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    //MARK: - Properties
    private var numberOfTaps: Int = 0
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.stopAnimating()
        self.label.text = String(numberOfTaps)
        self.button.layer.cornerRadius = 10
    }
    
    //MARK: - Actions
    @IBAction private func buttonPressed(_ sender: UIButton) {
        activityIndicator.startAnimating()
        activityIndicator.stopAnimating()
        numberOfTaps += 1
        label.text = String(numberOfTaps)
    }
}
