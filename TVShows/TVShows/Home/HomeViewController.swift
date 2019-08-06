//
//  HomeViewController.swift
//  TVShows
//
//  Created by Infinum on 18/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

final class HomeViewController: UIViewController {
    
    //MARK: - Properties
    private var shows: [Show] = []
    var token: String = ""
    private var isListView: Bool = true
    
    // MARK: - Private UI
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultMaskType(.black)
        setUpNavigationBar()
        _loadShows()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

// MARK: - UICollectionView
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        print("Selected show: \(show)")
        _showDetails(showId: show.id)
    }

}
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shows.count
    }
    func collectionView(_ tableView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ShowTableViewCell.self), for: indexPath) as! ShowTableViewCell
        cell.configure(show: shows[indexPath.row])
        return cell
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if isListView {

            return CGSize(width: width, height: 120)
        }else {
            return CGSize(width: 90, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}

//MARK: - Authorize user and set up UI
private extension HomeViewController {
    private func setUpNavigationBar(){
        navigationItem.title = "Shows"
        let logoutItem = UIBarButtonItem.init(
            image: UIImage(imageLiteralResourceName: "ic-logout"),
            style: .plain,
            target: self,
            action: #selector(_logout))
        logoutItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = logoutItem
        let toggleViewItem = UIBarButtonItem.init(
            image: UIImage(imageLiteralResourceName: "ic-gridview"),
            style: .plain,
            target: self,
            action: #selector(_toggleView))
        toggleViewItem.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = toggleViewItem
    }
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    private func _loadShows(){
        SVProgressHUD.show()
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
                    guard let self = self else { return }
                    self.shows = shows
                    self.setupCollectionView()
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Error")
                }
                SVProgressHUD.dismiss()
        }
    }
}

//MARK: - Log out user or change view
private extension HomeViewController {
    @objc private func _logout() {
        token = ""
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Login", bundle: bundle)
        let logInViewController = storyboard.instantiateViewController(
            withIdentifier: "LoginViewController"
            ) as! LoginViewController
        navigationController?.setViewControllers([logInViewController], animated: true)
        logInViewController.keychainUsername["user"] = nil
        logInViewController.keychainPassword["user"] = nil
    }
    @objc private func _toggleView() {
        if navigationItem.rightBarButtonItem?.image == UIImage(imageLiteralResourceName: "ic-gridview"){
            navigationItem.rightBarButtonItem?.image = UIImage(imageLiteralResourceName: "ic-listview")
            isListView = false
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(imageLiteralResourceName: "ic-gridview")
            isListView = true
        }
        collectionView.reloadData()
    }
}

//MARK: - Navigate to show details of the TV show
private extension HomeViewController {
    private func _showDetails(showId: String){
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "ShowDetails", bundle: bundle)
        let showDetailsViewController = storyboard.instantiateViewController(
            withIdentifier: "ShowDetailsViewController"
            ) as! ShowDetailsViewController
        navigationController?.pushViewController(showDetailsViewController, animated: true)
        showDetailsViewController.token = self.token
        showDetailsViewController.showId = showId
    }
}
