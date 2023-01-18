//
//  Compy-Paste.swift
//  SwiftUI-Content
//
//  Created by Leonardo Bonetti Maffei on 20/11/22.
//

import SwiftUI

struct CopyPasteView: View {
    @State private var text: String = ""
    @State private var buttonText: String = "Copy to Clipboard"
    private let pasteboard = UIPasteboard.general
    var body: some View {
        VStack {
            Text("Copy this text if you want")
                .textSelection(.enabled)
            TextField("Insert your text here", text: $text)
                .textFieldStyle(.roundedBorder)
            HStack {
                Button {
                    copyToClipboard()
                } label: {
                    Label(buttonText, systemImage: "doc.on.doc.fill")
                }
                Button {
                    paste()
                } label: {
                    Label("Paste", systemImage: "doc.on.clipboard")
                }
                .tint(.orange)
            }
        }
        .padding()
    }
    
    func paste() {
        if let string = pasteboard.string {
            text = string
        }
    }
    
    func copyToClipboard() {
        pasteboard.string = self.text
        self.text = ""
        self.buttonText = "Copied!"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.buttonText = "Copy to Clipboard"
        }
    }
}

struct Compy_Paste_Previews: PreviewProvider {
    static var previews: some View {
        CopyPasteView()
    }
}
