//
//  Episode.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Episode: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl: String
    let episodeNumber: String
    let season: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
        case id = "_id"
    }
}
