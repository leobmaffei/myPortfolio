//
//  PluggySwiftUIWebview.swift
//  SwiftUI-Content
//
//  Created by Sumup on 10/11/22.
//

import SwiftUI

struct PluggySwiftUIWebView: View {
    var body: some View {
        PluggyWebView()
    }
}

struct PluggyWebView : UIViewControllerRepresentable {

     func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

     }

     func makeUIViewController(context: Context) -> some UIViewController {
         return PluggyConnectWebView()
     }
}

struct PluggySwiftUIWebview_Previews: PreviewProvider {
    static var previews: some View {
        PluggySwiftUIWebView()
    }
}
