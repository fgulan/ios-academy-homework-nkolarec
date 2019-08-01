//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
    }
}

//MARK: - Set up UI
private extension CommentsViewController {
    private func setUpNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(
            image: UIImage(named: "ic-navigate-back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }
    @objc func goBack() {
        navigationController?.dismiss(animated: true)
    }
    
}
