//
//  Result.swift
//  API
//
//  Created by Rodrigo F Leite on 02/12/17.
//  Copyright © 2017 Rodrigo F Leite. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(String)
}
