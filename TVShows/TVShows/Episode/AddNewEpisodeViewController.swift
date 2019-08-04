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

protocol AddNewEpisodeDelegate: class {
    func refreshListOfEpisodes()
}

class AddNewEpisodeViewController: UIViewController {

    //MARK: - Properties
    var showId: String = ""
    var token: String = ""
    private var mediaId: String = ""
    private var pickedImage = UIImage()
    private let imagePicker = UIImagePickerController()
    weak var delegate: AddNewEpisodeDelegate?

    
    //MARK: - Outlets
    @IBOutlet private weak var epTitleTextField: UITextField!
    @IBOutlet private weak var seasonNumberTextfield: UITextField!
    @IBOutlet private weak var epNumberTextfield: UITextField!
    @IBOutlet private weak var epDescriptionTextField: UITextField!
    @IBOutlet private weak var episodeImage: UIImageView!
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        imagePicker.delegate = self
    }
    
    //MARK: - Actions
    @objc func cancelAddingNewEpisode() {
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
            animate(viewToShake: epTitleTextField)
            animate(viewToShake: seasonNumberTextfield)
            animate(viewToShake: epNumberTextfield)
            animate(viewToShake: epDescriptionTextField)
            return
        }
        let parameters: [String: String] = [
            "showId": showId,
            "title": episodeTitle,
            "description": episodeDescription,
            "mediaId": mediaId,
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
                    guard let self = self else { return }
                    self.delegate?.refreshListOfEpisodes()
                    self.navigationController?.dismiss(animated: true)
                    
                case .failure(let error):
                    print("API failure: \(error)")
                    guard let self = self else { return }
                    self.showAlert(title: "Add episode", message: "Failed to add a new episode.")
                }
                SVProgressHUD.dismiss()
            }
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        navigationController?.present(imagePicker, animated: true)
        guard let pickedImage = episodeImage.image else { return }
        if pickedImage != UIImage(contentsOfFile: "ic-camera"){
            _uploadImageOnAPI(pickedImage: pickedImage)
        }
    }
}

//MARK: - Navigation bar set up
private extension AddNewEpisodeViewController {
    private func setupNavigationBar(){
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
}

//MARK: - Pick an image from photo library
extension AddNewEpisodeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else { return }
        self.pickedImage = pickedImage
        picker.dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

//MARK: - Uploading image on episode
private extension AddNewEpisodeViewController {
    func _uploadImageOnAPI(pickedImage: UIImage) {
        let headers = ["Authorization": token]
        let imageByteData = pickedImage.pngData()!
        Alamofire
            .upload(multipartFormData: { multipartFormData in
            multipartFormData.append(
                imageByteData,
                withName: "file",
                fileName: "image.png",
                mimeType: "image/png")
            }, to: "https://api.infinum.academy/api/media",
               method: .post,
               headers: headers)
            { [weak self] result in
                switch result {
                case .success(let uploadRequest, _, _):
                    guard let self = self else { return }
                    self._processUploadRequest(uploadRequest)
                case .failure(let encodingError):
                    print("API failure: \(encodingError)")
            }
        }
                
    }
    func _processUploadRequest(_ uploadRequest: UploadRequest) {
        uploadRequest
            .responseDecodableObject(keyPath: "data") { [weak self]
            (response: DataResponse<Media>) in
            switch response.result {
            case .success(let media):
                print("DECODED: \(media)")
                print("Proceed to add episode call...")
                guard let self = self else { return }
                self.mediaId = media.id
            case .failure(let error):
                print("API failure: \(error)")
            }
        }
    }

}

