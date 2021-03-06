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
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .createUserSession, .deleteUserSession:
                return Endpoints.base + "/session"
            case .getUserData(let userId):
                return Endpoints.base + "/users/" + userId
            case .getStudentLocation:
                return Endpoints.base + "/StudentLocation?order=-updatedAt&limit=100"
            case .postStudentLocation:
                return Endpoints.base + "/StudentLocation"
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
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, isSecureResponse: Bool ,body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            let newData = isSecureResponse ? data.subdata(in: (5..<data.count)) : data
            
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func userLogOut(completionHandler: @escaping (Bool, Error?) -> Void){
        var request = URLRequest(url: Endpoints.deleteUserSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completionHandler(false, error)
                }
                return
            }
            DispatchQueue.main.async {
                completionHandler(true, nil)
            }
        }
        task.resume()
    }
    
    class func getUserData(accountId: String, completionHandler: @escaping (UserData?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getUserData(accountId).url, responseType: UserData.self, isSecureResponse: true) { response, error in
            if let response = response {
                completionHandler(response, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    class func getStudentLocation(completionHandler: @escaping ([StudentInformation]?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.getStudentLocation.url, responseType: StudentResponse.self, isSecureResponse: false) { response, error in
            if let response = response {
                completionHandler(response.results, nil)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    class func requestUserSesion(
        username: String, password: String, completionHandler: @escaping (String, Error?) -> Void) {
        let body = UserSessionRequest(udacity: UserCredentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.createUserSession.url, responseType: UserSession.self, isSecureResponse: true,body: body) { response, error in
            if let response = response {
                let accountKey  = response.account.key
                SessionManager.userAccountKey = accountKey
                completionHandler(accountKey, nil)
            } else {
                completionHandler("", error)
            }
        }
    }
    
    class func postStudentLocation(
        mapString: String, mediaUrl: String, latitude: Double, longitude: Double, completionHandler: @escaping (Bool, Error?) -> Void) {
        let userData = SessionManager.userData!
        let uniqueKey = SessionManager.userAccountKey!
        let body = StudentLocationRequest(uniqueKey: uniqueKey, firstName: userData.firstName, lastName: userData.lastName, mapString: mapString, mediaURL: mediaUrl, latitude: latitude, longitude: longitude)
        taskForPOSTRequest(url: Endpoints.postStudentLocation.url, responseType: StudentLocationPostResponse.self, isSecureResponse: false,body: body) { response, error in
            if response != nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, error)
            }
        }
    }
}
