//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/26/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let status: Int
    let error: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
