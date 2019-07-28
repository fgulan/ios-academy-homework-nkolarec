//
//  ShowDetails.swift
//  TVShows
//
//  Created by Infinum on 28/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct ShowDetails: Codable {
    let id: String
    let type: String
    let title: String
    let description: String
    let imageUrl: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case title
        case description
        case imageUrl
        case likesCount
        case id = "_id"
    }
}
