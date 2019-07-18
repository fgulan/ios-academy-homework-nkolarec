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
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var buttonCheck: UIButton!
    @IBOutlet weak var buttonLogIn: UIButton!
    @IBOutlet weak var buttonCreateAccount: UIButton!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonLogIn.layer.cornerRadius = 5
    }
    
    //MARK: - Actions
    @IBAction func buttonChecked(_ sender: UIButton) {
        buttonCheck.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControl.State#>)
    }
    
}
