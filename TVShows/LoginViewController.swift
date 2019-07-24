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
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
    }
    
    //MARK: - Actions
    @IBAction private func rememberMeChecked(_ sender: UIButton) {
        checkButton.isSelected.toggle()
    }
        
    @IBAction private func registerUser(_ sender: UIButton) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
        else {
            return
        }
        _registerUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction private func logInUser(_ sender: Any) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
            else {
                return
        }
        _loginUserWith(email: usernameTextField.text!, password: passwordTextField.text!)
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<User>) in
                switch response.result { 
                case .success(let user):
                    print("Success: \(user)")
                    self?._loginUserWith(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                }
        SVProgressHUD.dismiss()
        }
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
            .responseJSON { [weak self] dataResponse in
                switch dataResponse.result {
                case .success(let response):
                    print("Success: \(response)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    self?.navigationController?.pushViewController(HomeViewController.init(), animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Failure")
                }
        SVProgressHUD.dismiss()
        }
    }
    
}
