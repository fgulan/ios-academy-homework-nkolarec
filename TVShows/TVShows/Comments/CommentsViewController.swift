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

final class CommentsViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addCommentLabel: UITextField!

    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    
    //MARK: - Properties
    var episodeId: String = ""
    var token: String = ""
    private var comments: [Comment] = []
    private var notificationTokens: [NSObjectProtocol] = []
    
    deinit {
        notificationTokens.forEach(NotificationCenter.default.removeObserver)
    }
    
    //MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardEvent()
        _loadComments()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    @IBAction func navigateBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
        tableView.refreshControl?.tintColor = UIColor.gray
    }
    private func setupEmptyTableView(){
        let emptyView = UIView(frame: CGRect(x: tableView.center.x, y: tableView.center.y, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        let messageImage = UIImageView(image: UIImage(named: "img-placehoder-comments"))
        let messageLabel = UILabel()
        messageLabel.textColor = UIColor.gray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.text =
        "Sorry, we don't have comments yet. Be first who will write a review."
        emptyView.addSubview(messageImage)
        emptyView.addSubview(messageLabel)
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
        messageImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        messageImage.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        messageImage.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: messageImage.bottomAnchor, constant: 20).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 20).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -20).isActive = true
        tableView.backgroundView = emptyView
        tableView.backgroundView?.isHidden = false
        tableView.separatorStyle = .none
    }
    private func setupKeyboardEvent(){
            let willShowToken = NotificationCenter
                .default
                .addObserver(
                    forName: UIResponder.keyboardWillShowNotification,
                    object: nil,
                    queue: .main
                ){ [weak self] notification in
                    guard let userInfo = notification.userInfo else {return}
                    guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
                    let keyboardFrame = keyboardSize.cgRectValue
                    guard let self = self else { return }
                    self.bottomViewHeight.constant = keyboardFrame.height - 30
                    
            }
            let willHideToken = NotificationCenter
                .default
                .addObserver(
                    forName: UIResponder.keyboardWillHideNotification,
                    object: nil,
                    queue: .main
                ){ [weak self] notification in
                    guard let self = self else { return }
                    self.bottomViewHeight.constant = 5
            }
            notificationTokens.append(willHideToken)
            notificationTokens.append(willShowToken)
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        addCommentLabel.resignFirstResponder()
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
        if comments.count == 0 {
            setupEmptyTableView()
        } else {
            tableView.backgroundView?.isHidden = true
        }
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("CURRENT INDEX PATH BEING CONFIGURED: \(indexPath)")
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentTableViewCell.self), for: indexPath) as! CommentTableViewCell
        if  indexPath.row == 0 {
            cell.configure(comment: comments[indexPath.row], editFirstRow: true)
        } else { cell.configure(comment: comments[indexPath.row], editFirstRow: false) }
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
        let parameters: [String: String] = [
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
                headers: headers)
            .validate()
            .responseDecodableObject(keyPath: "data", decoder: JSONDecoder()) { [weak self] (response: DataResponse<CommentDetails>) in
                switch response.result {
                case .success(let commentDetails):
                    print("Success: \(commentDetails)")
                    SVProgressHUD.showSuccess(withStatus: "Success")
                    guard let self = self else { return }
                    self.tableView.refreshControl?.beginRefreshing()
                    let comment = Comment(
                        id: commentDetails.id,
                        text: commentDetails.text,
                        userEmail: commentDetails.userEmail,
                        episodeId: commentDetails.episodeId)
                    self.comments.append(comment)
                    self.tableView.reloadData()
                    self.tableView.refreshControl?.endRefreshing()
                    self.addCommentLabel.text = nil
                case .failure(let error):
                    print("API failure: \(error)")
                    SVProgressHUD.showError(withStatus: "Error")
                }
                SVProgressHUD.dismiss()
        }
    }
}
