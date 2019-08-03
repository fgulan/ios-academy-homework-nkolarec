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
import KeychainAccess

final class LoginViewController: UIViewController {
    
    //MARK: - Private UI
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var createAccountButton: UIButton!
    
    //MARK: - Properties
    let keychainUsername = Keychain(service: "username")
    let keychainPassword = Keychain(service: "password")
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
        if keychainPassword.allKeys().count > 0 && keychainUsername.allKeys().count > 0 {
            _loginUserAutomatically()
        }
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
            showAlert(title: "Register", message: "Fields must not be empty")
            return
        }
        _registerUserWith(email: username, password: password)
    }
    @IBAction private func logInUser(_ sender: Any) {
        guard
            let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty
            else {
                animate(viewToShake: usernameTextField)
                animate(viewToShake: passwordTextField)
                return
        }
        _loginUserWith(email: username, password: password)
    }
}

// MARK: - Register user
private extension LoginViewController {
    func _registerUserWith(email: String, password: String){
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
                    guard let self = self else { return }
                    self._loginUserWith(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                    guard let self = self else { return }
                    self.showAlert(title: "Register", message: "Failed to register.")
                }
        SVProgressHUD.dismiss()
        }
    }
}

// MARK: - Login user
private extension LoginViewController {
    func _loginUserWith(email: String, password: String) {
        SVProgressHUD.show()
        if checkButton.isSelected {
            rememberPassword(email: email, password: password)
        }
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
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<LoginData>) in
                switch response.result {
                case .success(let logInData):
                    print("Success: \(logInData.token)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    let bundle = Bundle.main
                    let storyboard = UIStoryboard(name: "Home", bundle: bundle)
                    let homeViewController = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                    ) as! HomeViewController
                    homeViewController.token = logInData.token
                    guard let self = self else { return }
                    self.navigationController?.setViewControllers([homeViewController], animated: true)
                case .failure(let error):
                    print("API failure: \(error)")
                    guard let self = self else { return }
                    self.animate(viewToShake: self.usernameTextField)
                    self.animate(viewToShake: self.passwordTextField)
                }
                SVProgressHUD.dismiss()
        }
    }
}

//MARK: - User's credentials
private extension LoginViewController {
    private func rememberPassword(email: String, password: String){
        do {
            try keychainUsername.set(email, key: "user")
            try keychainPassword.set(password, key: "user")
        } catch { print(error) }
        
    }
    private func _loginUserAutomatically(){
        do {
            guard
                let username = try keychainUsername.get("user"),
                let password = try keychainPassword.get("user"),
                !username.isEmpty,
                !password.isEmpty
                else { return }
            _loginUserWith(email: username, password: password)
        } catch { print(error) }
    }
}

//MARK: - Custom alert dialog on error
extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

//MARK: - Shake animation
extension UIViewController {
    func animate(viewToShake: UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x - 10, y: viewToShake.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: viewToShake.center.x + 10, y: viewToShake.center.y))
        viewToShake.layer.add(animation, forKey: "position")
    }
}

