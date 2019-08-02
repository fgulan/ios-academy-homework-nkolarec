//
//  Comment.swift
//  TVShows
//
//  Created by Infinum on 02/08/2019.
//  Copyright © 2019 Infinum Academy. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let id: String
    let text: String
    let email: String
    
    enum CodingKeys: String, CodingKey {
        case text
        case email
        case id = "_id"
    }
}
