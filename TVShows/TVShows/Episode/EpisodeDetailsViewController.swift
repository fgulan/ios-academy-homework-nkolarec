//
//  EpisodeDetailsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import CodableAlamofire
import Kingfisher
import SVProgressHUD

class EpisodeDetailsViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet private weak var episodeImage: UIImageView!
    @IBOutlet private weak var episodeTitle: UILabel!
    @IBOutlet private weak var seasonNumber: UILabel!
    @IBOutlet private weak var episodeNumber: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    var episodeId: String = ""
    var token: String = ""
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        _loadEpisodeDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    //MARK: Actions
    @IBAction func goToComments(_ sender: UIButton) {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Comments", bundle: bundle)
        let commentsViewController = storyboard.instantiateViewController(
            withIdentifier: "CommentsViewController"
            ) as! CommentsViewController
        self.navigationController?.pushViewController(commentsViewController, animated: true)
        commentsViewController.episodeId = episodeId
    }
    @IBAction func navigateBack(_ sender: UIButton) {
        cleanPropertiesAndUI()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - Load episode details
private extension EpisodeDetailsViewController {
    private func _loadEpisodeDetails(){
        SVProgressHUD.show()
        let parameters = ["episodeId": episodeId]
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/" + episodeId,
                method: .get,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            ).responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<EpisodeDetails>) in
                switch response.result {
                case .success(let episodeDetails):
                    print("Success: \(episodeDetails)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    guard let self = self else { return }
                    self.episodeTitle.text = episodeDetails.title
                    self.seasonNumber.text = episodeDetails.season
                    self.episodeNumber.text = episodeDetails.episodeNumber
                    self.descriptionLabel.text = episodeDetails.description
                    guard
                        let url = URL(string: "https://api.infinum.academy//" + episodeDetails.imageUrl)
                    else { return }
                    self.episodeImage.kf.setImage(with: url)
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Error")
                }
                SVProgressHUD.dismiss()
        }
    }
    private func cleanPropertiesAndUI() {
        self.episodeId = ""
        self.token = ""
    }
}
