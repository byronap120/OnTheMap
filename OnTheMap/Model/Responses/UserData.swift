//
//  UserData.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/19/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

struct UserData : Codable {
    let lastName: String
    let firstName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
        case nickname
    }
}
