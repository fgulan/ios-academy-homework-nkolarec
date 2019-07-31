//
//  Show.swift
//  TVShows
//
//  Created by Infinum on 27/07/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Show: Codable {
    let title: String
    let imageUrl: String
    let likesCount: Int
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl
        case likesCount
        case id = "_id"
    }
}
