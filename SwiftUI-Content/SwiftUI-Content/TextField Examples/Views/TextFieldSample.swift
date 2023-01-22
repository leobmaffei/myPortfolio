//
//  TextFieldSample.swift
//  SwiftUI-Content
//
//  Created by Sumup on 22/01/23.
//

import SwiftUI

struct TextFieldSample: View {
    @State var text = ""
    var body: some View {
        VStack {
            Group {
                /// In order to initialize a TextField, you need to pass in a placeholder string and a
                ///  binding to a @State variable which will store the value entered in the TextField.
                TextField("Enter username...", text: $text)

                ///The onCommit callback gets called when user taps return.
                ///The onEditingChanged is a little bit more tricky and gets called when user taps on
                /// the TextField or taps return. The changed value is set to true when user taps on the
                /// TextField and it’s set to false when user taps return.
                TextField("Enter username...",
                          text: $text,
                          onEditingChanged: { (changed) in
                    print("Username onEditingChanged - \(changed)")
                }) {
                    print("Username onCommit")
                }

                ///Add a border to a TextField using .textFieldStyle() modifier and RoundedBorderTextFieldStyle()
                TextField("Enter username...", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                ///Change input text color using .foregroundColor() modifier
                TextField("Enter username...", text: $text)
                    .foregroundColor(Color.blue)

                ///Change background color of a TextField using .background() modifier
                TextField("Enter username...", text: $text)
                    .background(Color.blue)

                ///Add a text label above the TextField using VStack
                VStack(alignment: .leading) {
                    Text("Username")
                        .font(.callout)
                        .bold()
                    TextField("Enter username...", text: $text)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }.padding()
        }
    }
}

struct TextFieldSample_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldSample()
    }
}
