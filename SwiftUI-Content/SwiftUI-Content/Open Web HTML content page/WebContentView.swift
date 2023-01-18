//
//  WebContentView.swift
//  SwiftUI-Content
//
//  Created by Sumup on 12/09/22.
//
import Foundation

struct localFileURL {
    let resource: String
    let ofType: String

    func load() -> String {
        Bundle.main.path(forResource: resource, ofType: ofType) ?? ""
    }
}
