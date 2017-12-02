//
//  Post.swift
//  API
//
//  Created by Rodrigo F Leite on 02/12/17.
//  Copyright © 2017 Rodrigo F Leite. All rights reserved.
//

import Foundation

struct Post: Codable {
    
    let id: Int
    let message: String
    let author: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case message = "message"
    }
    
}
