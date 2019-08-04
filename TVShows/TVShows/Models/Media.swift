//
//  Media.swift
//  TVShows
//
//  Created by Infinum on 03/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Media: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }
}
