//
//  PluggyAuthenticator.swift
//  SwiftUI-Content
//
//  Created by Sumup on 29/10/22.
//

import SwiftUI

struct PluggyAuthenticator: View {
    @State var showWebviewModal = false
    var body: some View {
        NavigationView {
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Auth on Pluggy").font(Font.system(.body)).bold()
                        Text("Open Webview as modal and authenticate from Pluggy").font(Font.system(.caption))
                    }
                    Spacer()
                    Button {
                        showWebviewModal = true
                    } label: {
                        Text("Authenticate")
                    }.sheet(isPresented: $showWebviewModal, content: {
                        PluggySwiftUIWebView()
                    })
                }
            }
            .navigationTitle("Auth with pluggy")
        }
    }
}

struct PluggyAuthenticator_Previews: PreviewProvider {
    static var previews: some View {
        PluggyAuthenticator()
    }
}
