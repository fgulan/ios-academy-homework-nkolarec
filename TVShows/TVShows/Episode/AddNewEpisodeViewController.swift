//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 29/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire

class AddNewEpisodeViewController: UIViewController {

    //MARK: - Properties
    var showId: String = ""
    var token: String = ""
    
    //MARK: - Outlets
    @IBOutlet weak var epTitleTextField: UITextField!
    @IBOutlet weak var seasonNumberTextfield: UITextField!
    @IBOutlet weak var epNumberTextfield: UITextField!
    @IBOutlet weak var epDescriptionTextField: UITextField!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Add episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addNewEpisode)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelAddingNewEpisode)
        )
    }
    
    //MARK: - Actions
    @objc func cancelAddingNewEpisode() {
        showId = ""
        token = ""
        navigationController?.dismiss(animated: true)
    }
    @objc func addNewEpisode() {
        guard
            let episodeTitle = epTitleTextField.text,
            let episodeSeasonNumber = seasonNumberTextfield.text,
            let episodeNumber = epNumberTextfield.text,
            let episodeDescription = epDescriptionTextField.text,
            !episodeTitle.isEmpty,
            !episodeSeasonNumber.isEmpty,
            !episodeNumber.isEmpty,
            !episodeDescription.isEmpty
        else {
            showAlert(title: "Add episode", message: "Fields must not be empty.")
            return
        }
        let parameters: [String: String] = [
            "showId": showId,
            "title": episodeTitle,
            "description": episodeDescription,
            "imageUrl": "",
            "episodeNumber": episodeNumber,
            "season": episodeSeasonNumber
        ]
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<Episode>) in
                switch response.result {
                case .success(let episode):
                    print("Success: \(episode)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    
                    self?.navigationController?.dismiss(animated: true)
                    
                case .failure(let error):
                    print("API failure: \(error)")
                    self?.showAlert(title: "Add episode", message: "Failed to add a new episode.")
                }
                SVProgressHUD.dismiss()
            }
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        //for later
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}
