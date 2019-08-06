//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class CommentTableViewCell: UITableViewCell {

    //MARK: - Outlets
    @IBOutlet private weak var commentImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    @IBOutlet weak var lineView: UIView!
    
    //MARK: - Properties
    private var generator: Int = 0
    
    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = nil
        usernameLabel.text = nil
        commentImage.image = nil
    }
}

// MARK: - Configure
extension CommentTableViewCell {
    func configure(comment: Comment, editFirstRow: Bool) {
        usernameLabel.text = comment.userEmail
        generator = Int.random(in: 0 ... 10)
        if generator % 3 == 1 {
            commentImage.image = UIImage(named: "img-placeholder-user1")
        }
        else if generator % 3 == 2 {
            commentImage.image = UIImage(named: "img-placeholder-user2")
        } else {
            commentImage.image = UIImage(named: "img-placeholder-user3")
        }
        commentLabel.text = comment.text
        if editFirstRow == true {
            lineView.backgroundColor = UIColor.white
        }
    }
}
