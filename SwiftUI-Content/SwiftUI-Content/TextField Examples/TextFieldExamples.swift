//
//  TextFieldExamples.swift
//  SwiftUI-Content
//
//  Created by Leonardo Maffei on 19/01/23.
//

import SwiftUI

struct TextFieldExamples: View {
    @State var username = ""
    var body: some View {
        List {
            NeumorphicStyleTextFieldExample()
            OvalStyleTextField()
            GradientStyleTextfield()
            StrokedStyleTextField()
            UnderlinedStyleTextField()
        }.listStyle(.inset)
    }
}
struct TextFieldExamples_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldExamples()
    }
}
