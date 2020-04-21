//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/18/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import Foundation

class UdacityAPI {
    
    enum Endpoints {
        case createUserSession
        case deleteUserSession
        case getUserData(String)
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .createUserSession, .deleteUserSession:
                return "https://onthemap-api.udacity.com/v1/session"
            case .getUserData(let userId):
                return "https://onthemap-api.udacity.com/v1/users/" + userId
            }
        }
    }
    
    class func requestUserSesion(
        username: String, password: String, completionHandler: @escaping (String, Error?) -> Void) {
        
        let body = UserSessionRequest(udacity: UserCredentials(username: username, password: password))
        var request = URLRequest(url: Endpoints.createUserSession.url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler("", error)
                }
                return
            }
            
            let newData = data.subdata(in: (5..<data.count))
            let decoder = JSONDecoder()
            
            do {
                let userSessionResponse = try decoder.decode(UserSession.self, from: newData)
                let accountKey  = userSessionResponse.account.key
                DispatchQueue.main.async {
                    completionHandler(accountKey, nil)
                }
            } catch {
                let error = ErrorResponse(statusMessage: "Invalid User Credentials") as Error
                DispatchQueue.main.async {
                    completionHandler("", error)
                }
            }
            
        }
        task.resume()
    }
    
    class func getUserData(accountId: String, completionHandler: @escaping (UserData?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getUserData(accountId).url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
                return
            }
            
            let newData = data.subdata(in: (5..<data.count))
            let decoder = JSONDecoder()
            
            do {
                let userData = try decoder.decode(UserData.self, from: newData)
                DispatchQueue.main.async {
                    completionHandler(userData, nil)
                }
            } catch {
                let error = ErrorResponse(statusMessage: "Invalid User Data") as Error
                DispatchQueue.main.async {
                    completionHandler(nil, error)
                }
            }
            
        }
        task.resume()
    }
    
    
}
