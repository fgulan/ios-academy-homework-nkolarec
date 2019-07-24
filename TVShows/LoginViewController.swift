//
//  LoginViewController.swift
//  TVShows
//
//  Created by Infinum on 11/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

final class LoginViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    //MARK: - Properties
    private var isChecked: Bool = false
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Actions
    @IBAction func rememberMeChecked(_ sender: UIButton) {
       
        if(isChecked == false){
            checkButton.setImage(UIImage(named: "ic-checkbox-filled"), for: UIControl.State.normal)
            isChecked = true
        }
        else{
            checkButton.setImage(UIImage(named: "ic-checkbox-empty"), for: UIControl.State.normal)
            isChecked = false
        }
    }
        
    @IBAction func registerUser(_ sender: UIButton) {
        if(usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty){
            print("One of the fields is empty")
        } else {
            _registerUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
        }
        
    }
    
    @IBAction func logInUser(_ sender: Any) {
        if(usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty){
            print("One of the fields is empty")
        } else {
            _loginUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
        }
    }
}

// MARK: - Register
private extension LoginViewController {
    
    func _registerUserWith(email: String, password: String) {
        SVProgressHUD.show()
        
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        Alamofire
            .request(
                "https://api.infinum.academy/api/users",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { (response: DataResponse<User>) in
                switch response.result {
                case .success(let user):
                    print("Success: \(user)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
        SVProgressHUD.dismiss()
    }
    
}

// MARK: - Login
private extension LoginViewController {
    
    func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        Alamofire
            .request(
                "https://api.infinum.academy/api/users/sessions",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let response):
                    print("Success: \(response)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        }
        SVProgressHUD.dismiss()
    }
    
}
