//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 18/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

protocol HomeViewControllerDelegate : class {
    func loggedInUser() -> User
}

final class HomeViewController: UIViewController {
    
    private var currentUser: User!

    weak var delegate:HomeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = delegate?.loggedInUser()
    }
}
