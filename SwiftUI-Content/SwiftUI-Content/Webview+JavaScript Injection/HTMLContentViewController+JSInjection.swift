//
//  HTMLContentViewController+JSInjection.swift
//  SwiftUI-Content
//
//  Created by Sumup on 02/11/22.
//

import Foundation

class HTMLContentJSInjectionViewController: WebContentViewController {
    
    let injectedArguments: [String: String]
    
    init(pathURL: String, isLocalFile: Bool = false, fileFormat: String = "html", injection: [String: String]) {
        self.injectedArguments = injection
        super.init(pathURL: pathURL, isLocalFile: isLocalFile, fileFormat: fileFormat)
    }

    private func injectContent() {
        let jsonInjection = JSONFormatter().convert(dict: injectedArguments)

        // The function is the name of the function created on JS
        self.webView.evaluateJavaScript("function('\(jsonInjection)')") { (any, error) in
            print("Error : \(String(describing: error))")
        }

        print(jsonInjection)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if Float(webView.estimatedProgress) >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.activityView.stopAnimating()
                    if self.isLocalFile {
                        self.injectContent()
                    }
                 }
            }
        }
    }
}
