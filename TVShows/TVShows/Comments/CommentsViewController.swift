//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var episodeId: String = ""
    var token: String = ""
    private var comments: [Comment] = []
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    @IBAction func postComment(_ sender: UIButton) {
        //Post API call
    }
}

//MARK: - Set up UI
private extension CommentsViewController {
    private func setUpNavigationBar(){
        navigationItem.title = "Comments"
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(
            image: UIImage(contentsOfFile: "ic-navigate-back"),
            style: .plain,
            target: self,
            action: #selector(goBack)
        )
    }
    @objc func goBack() {
        comments = []
        episodeId = ""
        token = ""
        navigationController?.dismiss(animated: true)
    }
    
}

// MARK: - UITableView
extension CommentsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            comments.remove(at: indexPath.row)
            //make api call for removing comment
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension CommentsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
        cell.configure(comment: comments[indexPath.row])
        return cell
    }
}

private extension CommentsViewController {
    private func setupTableView() {
        tableView.estimatedRowHeight = 110
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
    }
}
