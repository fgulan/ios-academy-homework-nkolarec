//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 18/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire

final class HomeViewController: UIViewController {
    
    var token: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for some reason it doesn't change when I try to change it in the LoginViewController
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/shows",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers
            ).responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Show]>) in
                switch response.result {
                case .success(let shows):
                    print("Success: \(shows)")
                case .failure(let error):
                    print("API failure: \(error)")
                }
        }
    }
}
