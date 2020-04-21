//
//  ErrorResponse.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/19/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct ErrorResponse : LocalizedError {
    let statusMessage: String
    
    var errorDescription: String? {
        return statusMessage
    }
}
