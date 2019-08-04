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
    
    // MARK: - Private UI
    @IBOutlet private weak var tableView: UITableView!
    
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

// MARK: - UITableView
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let show = shows[indexPath.row]
        print("Selected show: \(show)")
        _showDetails(showId: show.id)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shows.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ShowTableViewCell.self), for: indexPath) as! ShowTableViewCell
        cell.configure(show: shows[indexPath.row])
        return cell
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
        navigationItem.leftBarButtonItem = logoutItem
        let toggleViewItem = UIBarButtonItem.init(
            image: UIImage(imageLiteralResourceName: "ic-gridview"),
            style: .plain,
            target: self,
            action: #selector(_toggleView))
        navigationItem.rightBarButtonItem = toggleViewItem
    }
    private func setupTableView() {
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
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
                    self.setupTableView()
                    self.tableView.reloadData()
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
        } else {
            navigationItem.rightBarButtonItem?.image = UIImage(imageLiteralResourceName: "ic-gridview")
        }
        //change view
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
