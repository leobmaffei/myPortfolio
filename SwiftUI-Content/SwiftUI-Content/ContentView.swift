//
//  ContentView.swift
//  SwiftUI-Content
//
//  Created by Sumup on 11/09/22.
//

import SwiftUI

struct ContentView: View {
    @State var showWebviewModal = false
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: SwiftUIWebView(url: "https://google.com")) {
                    VStack(alignment: .leading) {
                        Text("WebView on swiftUI").font(Font.system(.body)).bold()
                        Text("SwiftUI don't have webviews, so I created one based on WKWebView").font(Font.system(.caption))
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("Modal WebView on swiftUI").font(Font.system(.body)).bold()
                        Text("Open Webview as modal using custom webview").font(Font.system(.caption))
                    }
                    Spacer()
                    Button {
                        showWebviewModal = true
                    } label: {
                        Text("Open")
                    }.sheet(isPresented: $showWebviewModal, content: {
                        SwiftUIWebView(url: "https://google.com")
                    })
                }

                NavigationLink(destination: SwiftUIWebView(url: localFileURL(resource: "index",
                                                                             ofType: "html").load(),
                                                           isLocalFile: true)) {
                    VStack(alignment: .leading) {
                        Text("Open Local HTML content").font(Font.system(.body)).bold()
                        Text("Open a webview site or local HTML page with WkWebKit").font(Font.system(.caption))
                    }
                }

                NavigationLink(destination: SwiftUIWebView(url: localFileURL(resource: "index",
                                                                             ofType: "html").load(),
                                                           isLocalFile: true,
                                                           injectContent: ["clientUserId" : "leobmaffei@gmail.com"])) {
                    VStack(alignment: .leading) {
                        Text("Inject content in local javaScript").font(Font.system(.body)).bold()
                        Text("Open a webview site or local HTML page with WkWebKit and inject content in the javascript").font(Font.system(.caption))
                    }
                }
                NavigationLink(destination: PluggySwiftUIWebView()) {
                    VStack(alignment: .leading) {
                        Text("Open banking Connection").font(Font.system(.body)).bold()
                        Text("Open a webview site to connect with open banking accounts using pluggy.ai").font(Font.system(.caption))
                    }
                }
                VStack(alignment: .leading) {
                    Text("Copy and Paste").font(Font.system(.body)).bold()
                    CopyPasteView().buttonStyle(.plain)
                }
                NavigationLink(destination: BasicLoginScreen()) {
                    VStack(alignment: .leading) {
                        Text("Basic Login Screen").font(Font.system(.body)).bold()
                        Text("Basic login screen with show and hide password button").font(Font.system(.caption))
                    }
                }
            }
            .navigationTitle("SwiftUI")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
