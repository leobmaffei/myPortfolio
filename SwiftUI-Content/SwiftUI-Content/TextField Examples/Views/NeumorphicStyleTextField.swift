//
//  NeumorphicStyleTextField.swift
//  SwiftUI-Content
//
//  Created by Sumup on 22/01/23.
//

import SwiftUI

struct NeumorphicStyleTextField: View {
    var textField: TextField<Text>
    var imageName: String
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .foregroundColor(.darkShadow)
            textField
            }
            .padding()
            .foregroundColor(.neumorphictextColor)
            .background(Color.background)
            .cornerRadius(6)
            .shadow(color: Color.darkShadow, radius: 3, x: 2, y: 2)
            .shadow(color: Color.lightShadow, radius: 3, x: -2, y: -2)

        }
}

struct NeumorphicStyleTextFieldExample: View {
    @State var text = ""
    var body: some View {
        ZStack {
            Color.background.ignoresSafeArea()
            VStack(alignment: .leading) {
                Text("Neumorphic").font(.title2).foregroundColor(.neumorphictextColor)
                HStack {
                    NeumorphicStyleTextField(textField: TextField("Search...", text: $text), imageName: "magnifyingglass")
                }
            }.padding()
        }
    }
}

struct NeumorphicStyleTextField_Previews: PreviewProvider {
    static var previews: some View {
        NeumorphicStyleTextFieldExample()
    }
}
