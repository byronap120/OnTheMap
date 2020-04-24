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
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createUserSession
        case deleteUserSession
        case getUserData(String)
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            case .createUserSession, .deleteUserSession:
                return Endpoints.base + "/session"
            case .getUserData(let userId):
                return Endpoints.base + "/users/" + userId
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?limit=100?order=-updatedAt"
            }
        }
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isSecureResponse: Bool ,completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            let newData = isSecureResponse ? data.subdata(in: (5..<data.count)) : data
            
            let temp = String(data: newData, encoding: .utf8)!
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                let error = ErrorResponse(statusMessage: "Unknown Error") as Error
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
        return task
    }
    
    
    class func getUserData(accountId: String, completionHandler: @escaping (UserData?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(accountId).url, responseType: UserData.self, isSecureResponse: true) { response, error in
            if let response = response {
                completionHandler(response, nil)
            } else {
                let error = ErrorResponse(statusMessage: "Invalid User Credentials") as Error
                completionHandler(nil, error)
            }
        }
    }
    
    class func getStudentLocation(completionHandler: @escaping ([StudentLocation]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentResponse.self, isSecureResponse: false) { response, error in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                let error = ErrorResponse(statusMessage: "Errog Getting Students locations") as Error
                completionHandler(nil, error)
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
    
    //    class func getUserData(accountId: String, completionHandler: @escaping (UserData?, Error?) -> Void) {
    //        let task = URLSession.shared.dataTask(with: Endpoints.getUserData(accountId).url) { data, response, error in
    //            guard let data = data else {
    //                DispatchQueue.main.async {
    //                    completionHandler(nil, error)
    //                }
    //                return
    //            }
    //
    //            let newData = data.subdata(in: (5..<data.count))
    //            let decoder = JSONDecoder()
    //
    //            do {
    //                let userData = try decoder.decode(UserData.self, from: newData)
    //                DispatchQueue.main.async {
    //                    completionHandler(userData, nil)
    //                }
    //            } catch {
    //                let error = ErrorResponse(statusMessage: "Invalid User Data") as Error
    //                DispatchQueue.main.async {
    //                    completionHandler(nil, error)
    //                }
    //            }
    //
    //        }
    //        task.resume()
    //    }
    
    
}
