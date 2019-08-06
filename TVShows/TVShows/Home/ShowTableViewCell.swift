//
//  TableViewCell.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit
import Kingfisher

final class ShowTableViewCell: UICollectionViewCell {

    // MARK: - Private UI
    @IBOutlet private weak var title: UILabel!
    @IBOutlet weak var showImage: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title.text = nil
        showImage.image = nil
    }
}

// MARK: - Configure
extension ShowTableViewCell {
    func configure(show: Show) {
        title.text = show.title
        guard let url = URL(string: "https://api.infinum.academy" + show.imageUrl)
        else { return }
        showImage.kf.setImage(with: url)
    }
}
