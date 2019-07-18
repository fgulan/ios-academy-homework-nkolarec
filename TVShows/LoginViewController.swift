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
    @IBOutlet private weak var buttonLogIn: UIButton!
    @IBOutlet private weak var buttonCreateAccount: UIButton!
    
    //MARK: - Properties
    private var isChecked: Bool = false
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonLogIn.layer.cornerRadius = 5
    }
    
    //MARK: - Actions
    @IBAction func buttonChecked(_ sender: UIButton) {
       
        if(isChecked == false){
            buttonCheck.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControl.State.normal)
            isChecked = true
        }
        else{
            buttonCheck.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControl.State.normal)
            isChecked = false
        }
    }
    @IBAction func logIn(_ sender: UIButton) {
    }
    @IBAction func createAccount(_ sender: UIButton) {
    }
}
