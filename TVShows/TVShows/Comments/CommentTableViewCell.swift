//
//  CommentTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 01/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet private weak var commentImage: UIImageView!
    @IBOutlet private weak var usernameLabel: UILabel!
    @IBOutlet private weak var commentLabel: UILabel!
    override func prepareForReuse() {
        super.prepareForReuse()
        commentLabel.text = nil
        usernameLabel.text = nil
        commentImage.image = nil
    }
}

// MARK: - Configure
extension CommentTableViewCell {
    func configure(comment: Comment) {
        commentLabel.text = comment.text
        usernameLabel.text = comment.email
    }
}
