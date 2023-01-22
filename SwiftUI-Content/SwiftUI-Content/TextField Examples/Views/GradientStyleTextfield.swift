//
//  GradientStyleTextfield.swift
//  SwiftUI-Content
//
//  Created by Sumup on 22/01/23.
//

import SwiftUI

///This time the way to make it reusable is to extend the TextField View, the same you would do to add a modifier to an Image or to
///create your own custom color. This is how it will look. Note, that this extension can only be applied to a TextField as it is a modifier
///for that specific view.
extension TextField {
    func extensionTextFieldView(roundedCornes: CGFloat, startColor: Color,  endColor: Color) -> some View {
        self
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .shadow(color: .purple, radius: 10)
    }
}

struct GradientStyleTextfield: View {
    @State var text = ""
    var body: some View {
        ///Custom textfield modifiers
        VStack(alignment: .leading) {
            Text("Gradient Style").font(.title2).foregroundColor(.purple)
            TextField("Search...", text: $text).extensionTextFieldView(roundedCornes: 6, startColor: .white, endColor: .purple)
        }.padding()
    }
}

struct GradientStyleTextfield_Previews: PreviewProvider {
    static var previews: some View {
        GradientStyleTextfield()
    }
}
