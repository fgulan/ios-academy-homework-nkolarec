//
//  EpisodeTableViewCell.swift
//  TVShows
//
//  Created by Infinum on 29/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet private weak var seasonNumberLabel: UILabel!
    @IBOutlet private weak var episodeNumberLabel: UILabel!
    @IBOutlet private weak var episodeTitleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        episodeTitleLabel.text = nil
        episodeNumberLabel.text = nil
        seasonNumberLabel.text =  nil
    }
}
// MARK: - Configure
extension EpisodeTableViewCell {
    func configure(episode: Episode) {
        episodeTitleLabel.text = episode.title
        episodeNumberLabel.text = episode.episodeNumber
        seasonNumberLabel.text =  episode.season
    }
}

