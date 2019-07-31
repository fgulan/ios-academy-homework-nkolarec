//
//  TableViewCell.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

final class ShowTableViewCell: UITableViewCell {

    // MARK: - Private UI
    @IBOutlet private weak var title: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
    }
}

// MARK: - Configure
extension ShowTableViewCell {
    func configure(show: Show) {
        title.text = show.title
    }
}

// MARK: - Private
private extension ShowTableViewCell {
    func setupUI() {
        //for later
    }
}
