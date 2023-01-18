//
//  TextFieldMaskView.swift
//  SwiftUI-Content
//
//  Created by Sumup on 02/12/22.
//

import SwiftUI
import Combine

struct TextFieldMaskView: View {
    @State private var textFieldContent: String = ""
    // mask example: "XXXX-XXXXX"
    let mask: String
    var body: some View {
        TextField("Text Content", text: $textFieldContent)
            .onReceive(Just(textFieldContent)) { text in
                self.textFieldContent = text.format(with: mask)
            }
    }
}

struct TextFieldMaskView_Previews: PreviewProvider {
    @State private var textFieldContent: String = ""
    static var previews: some View {
        VStack {
            TextFieldMaskView(mask: "(XX) XXXXX-XXXX")
                .background(Color.mint)
                .padding()
        }

    }
}

extension String {
    enum RegexContent: String {
        case numbers = "[^0-9]"
        case characters = "[^A-Za-z]"
        case charsAndNumbers = "[^A-Za-z0-9]"
    }
    /// mask example: `+XX (XX) XXX-XXXX`
    func format(with mask: String, allowedCaracters: RegexContent = .charsAndNumbers) -> String {
        let regex = self.replacingOccurrences(of: allowedCaracters.rawValue, with: "", options: .regularExpression)
        var result = ""
        var index = regex.startIndex
        for ch in mask where index < regex.endIndex {
            if ch == "X" {
                result.append(regex[index])
                index = regex.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}
