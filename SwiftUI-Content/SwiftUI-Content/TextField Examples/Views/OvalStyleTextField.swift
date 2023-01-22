//
//  OvalStyleTextField.swift
//  SwiftUI-Content
//
//  Created by Sumup on 22/01/23.
//

import SwiftUI

///TextFieldStyle is a modifier which means we can configure a new TextField style in the view hierarchy.
struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [Color.orange, Color.orange]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .shadow(color: .gray, radius: 10)
    }
}

struct OvalStyleTextField: View {
    @State var text = ""
    var body: some View {
        ///Custom textfield modifiers
        VStack(alignment: .leading) {
            Text("Oval Style").font(.title2)
            TextField("Enter username...", text: $text)
                .textFieldStyle(OvalTextFieldStyle())
        }.padding()
    }
}

struct OvalStyleTextField_Previews: PreviewProvider {
    static var previews: some View {
        OvalStyleTextField()
    }
}
