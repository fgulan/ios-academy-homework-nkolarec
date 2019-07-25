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
    private var currentUser: User!
    
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logInButton.layer.cornerRadius = 5
        SVProgressHUD.setDefaultMaskType(.black)
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? HomeViewController {
            destinationVC.delegate = self
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
                showAlert(title: "Login", message: "Fields must not be empty")
                return
        }
        _loginUserWith(email: username, password: password)
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
                    self?.currentUser = user
                    self?._loginUserWith(email: email, password: password)
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.showAlert(title: "Register", message: "Failed to register.")
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
                    
                    let bundle = Bundle.main
                    let storyboard = UIStoryboard(name: "Home", bundle: bundle)
                    let homeViewController = storyboard.instantiateViewController(
                        withIdentifier: "HomeViewController"
                    )
                    
                    self?.navigationController?.pushViewController(homeViewController, animated: true)
                    
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.showAlert(title: "Login", message: "Failed to login.")
                }
        SVProgressHUD.dismiss()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension LoginViewController : HomeViewControllerDelegate {
    func loggedInUser() -> User {
        return currentUser
    }
}
