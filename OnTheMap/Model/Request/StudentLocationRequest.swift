//
//  StudentLocationRequest.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/25/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct StudentLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
