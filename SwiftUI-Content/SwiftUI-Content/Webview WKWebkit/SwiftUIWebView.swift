//
//  WebView.swift
//  SwiftUI-Content
//
//  Created by Sumup on 12/09/22.
//

import SwiftUI

struct SwiftUIWebView: View {
    let url: String
    let isLocalFile: Bool
    let injectContent: [String: String]?
    
    init(url: String, isLocalFile: Bool = false, injectContent: [String: String]? = nil) {
        self.url = url
        self.isLocalFile = isLocalFile
        self.injectContent = injectContent
    }
    
    var body: some View {
        if injectContent == nil {
            WebView(url: url, islocalFile: isLocalFile)
        } else {
            WebViewInjection(url: url, islocalFile: isLocalFile, injection: injectContent ?? ["":""])
        }
    }
}

struct WebView : UIViewControllerRepresentable {
    
    let url: String
    let islocalFile: Bool
    
     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

     }

     func makeUIViewController(context: Context) -> some UIViewController {
         return WebContentViewController(pathURL: url, isLocalFile: islocalFile)
     }
}

struct WebViewInjection : UIViewControllerRepresentable {
    
    let url: String
    let islocalFile: Bool
    let injection: [String: String]
    
     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

     }

     func makeUIViewController(context: Context) -> some UIViewController {
         return HTMLContentJSInjectionViewController(pathURL: url, isLocalFile: islocalFile, injection: injection)
     }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIWebView(url: "https://google.com", isLocalFile: false)
    }
}
