//
//  CommentsViewController.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import SVProgressHUD
import Alamofire
import CodableAlamofire

class CommentsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addCommentLabel: UITextField!
    
    //MARK: - Properties
    var episodeId: String = ""
    var token: String = ""
    private var comments: [Comment] = []
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        _loadComments()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Actions
    @IBAction func postComment(_ sender: UIButton) {
        guard
            let newComment = addCommentLabel.text,
            !newComment.isEmpty
        else {
            return
        }
        _postComment(text: newComment)
    }
}

//MARK: - Set up UI
private extension CommentsViewController {
    private func setupTableView() {
        tableView.estimatedRowHeight = 72
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
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

//MARK: - Load comments
private extension CommentsViewController {
    private func _loadComments(){
        SVProgressHUD.show()
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/episodes/" + episodeId + "/comments",
                method: .get,
                encoding: JSONEncoding.default,
                headers: headers
            ).responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<[Comment]>) in
                switch response.result {
                case .success(let comments):
                    print("Success: \(comments)")
                    guard let self = self else { return }
                    self.comments = comments
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

//MARK: - Post a comment
private extension CommentsViewController {
    private func _postComment(text: String){
        SVProgressHUD.show()
        let parameters = [
            "text": text,
            "episodeId": episodeId
        ]
        let headers = ["Authorization": token]
        Alamofire
            .request(
                "https://api.infinum.academy/api/comments",
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            ).responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<Comment>) in
                switch response.result {
                    case .success(let comment):
                        print("Success: \(comment)")
                        guard let self = self else { return }
                        self._loadComments()
                    case .failure(let error):
                        print("API failure: \(error)")
                        SVProgressHUD.showError(withStatus: "Error")
                }
                SVProgressHUD.dismiss()
        }
    }
}
