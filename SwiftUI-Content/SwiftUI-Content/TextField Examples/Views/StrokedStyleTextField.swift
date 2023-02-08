//
//  StrokedStyleTextField.swift
//  SwiftUI-Content
//
//  Created by Leonardo Maffei on 22/01/23.
//

import SwiftUI

///We can also create a viewModifier to make uor custom textfield.
///This also can be used in every view not only in textfields
struct StrokedStyleView: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(3)
            .foregroundColor(textColor)
            .overlay(RoundedRectangle(cornerRadius: roundedCornes)
                .stroke(LinearGradient(gradient: Gradient(colors: [startColor, endColor]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
            .font(.custom("Open Sans", size: 18))
            .shadow(radius: 10)
    }
}

extension View {
    func strokedStyle(roundedCornes: CGFloat, startColor: Color, endColor: Color, textColor: Color) -> some View {
        modifier(StrokedStyleView(roundedCornes: roundedCornes, startColor: startColor, endColor: endColor, textColor: textColor))
    }
}
struct StrokedStyleTextField: View {
    @State var text = ""
    var body: some View {
        ///Custom textfield modifiers
        VStack(alignment: .leading) {
            Text("Stroked Style").font(.title2).foregroundColor(.orange)
            ///CustomViewmodifiers that can be used in all views
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search...", text: $text)
            }.strokedStyle(roundedCornes: 6, startColor: .orange, endColor: .purple, textColor: .white)
        }.padding()
    }
}

struct StrokedStyleTextField_Previews: PreviewProvider {
    static var previews: some View {
        StrokedStyleTextField()
    }
}
