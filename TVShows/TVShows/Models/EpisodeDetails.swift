//
//  EpisodeDetails.swift
//  TVShows
//
//  Created by Infinum on 04/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct EpisodeDetails: Codable {
    let id: String
    let title: String
    let description: String
    let imageUrl:String
    let episodeNumber: String
    let season: String
    let showId: String
    let type: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case imageUrl
        case episodeNumber
        case season
        case showId
        case type
        case id = "_id"
    }
}
