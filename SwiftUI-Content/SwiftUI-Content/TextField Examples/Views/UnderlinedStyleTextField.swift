//
//  UnderliedStyleTextField.swift
//  SwiftUI-Content
//
//  Created by Sumup on 22/01/23.
//

import SwiftUI

extension View {
    func underlineTextField() -> some View {
        self
            .padding(.vertical, 10)
            .overlay(Rectangle().frame(height: 2).padding(.top, 35))
            .foregroundColor(.darkPink)
            .padding(10)
    }
}

struct UnderliedStyleTextField: View {
    @State var text = ""
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Underlined TextField Style").font(.title2)
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $text)
                }.underlineTextField()
            }.padding()
        }
    }
}

struct UnderliedStyleTextField_Previews: PreviewProvider {
    static var previews: some View {
        UnderliedStyleTextField()
    }
}
