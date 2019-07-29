//
//  AddNewEpisodeViewController.swift
//  TVShows
//
//  Created by Infinum on 29/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

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
            action: #selector(addNewShow)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelAddingNewEpisode)
        )
    }
    
    //MARK: - Actions
    @objc func addNewShow() {
    }
    @objc func cancelAddingNewEpisode() {
        showId = ""
        token = ""
        navigationController?.dismiss(animated: true)
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        //for later
    }
}
