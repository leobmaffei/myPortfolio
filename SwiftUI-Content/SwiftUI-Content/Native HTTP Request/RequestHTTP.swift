//
//  RequestHTTP.swift
//  SwiftUI-Content
//

import Foundation

enum RequestHTTPMethod:String {
    case POST = "POST"
    case GET = "GET"
    case PUT = "PUT"
}

class RequestService {
    func httpRequest <T: Codable>(
            method: RequestHTTPMethod,
            endpoint: String,
            headers: [String: Any] = [:],
            parameters: [String: Any],
            completion: @escaping(T?, URLResponse?, Error?) -> Void
        ) {
        guard let url = URL(string: endpoint) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            headers.forEach { (key: String, value: Any) in
                request.setValue(value as? String, forHTTPHeaderField: key)
            }
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        request.timeoutInterval = 20
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil, response, error)
                return
            }
            completion(try? JSONFormatter().customDecoder().decode(T.self, from: data), response, nil)
            
            }.resume()
    }
}
