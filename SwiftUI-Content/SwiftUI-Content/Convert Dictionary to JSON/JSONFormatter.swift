//
//  DictToJSON.swift
//  SwiftUI-Content
//
//  Created by Sumup on 01/11/22.
//

import Foundation

struct JSONFormatter {
    func convert(dict: [String: String]) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dict) {
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                return ""
            }
            return jsonString
        } else {
            return ""
        }
    }
    
    func customDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
            decoder.dateDecodingStrategy = .iso8601
        }
        return decoder
    }
}
