//
//  MaterialStyleTextField.swift
//  SwiftUI-Content
//
//  Created by Leonardo Maffei on 28/01/23.
//

import SwiftUI

final class MaterialStyleTextFieldViewModel: ObservableObject {
    let placeholder1 = "Placeholder 1"
    let placeholder2 = "Placeholder 2"
    @Published var text1 = ""
    @Published var text2 = ""
    @Published var hint1 = "Hint 1"
    @Published var hint2 = "Hint 2"
    @Published var text1Valid = true {
      didSet {
        hint1 = text1Valid ? "Hint 1" : "Error 1"
      }
    }
    @Published var text2Valid = true {
      didSet {
        hint2 = text2Valid ? "Hint 2" : "Error 2"
      }
    }

    func validateText1() {
      text1Valid.toggle() // Demonstrative dummy validation.
    }

    func validateText2() {
      text2Valid.toggle() // Demonstrative dummy validation.
    }

}

struct MaterialStyleTextField: View {

    var body: some View {
        ZStack {
          TextField("", text: $text)
            .padding(6.0)
            .background(RoundedRectangle(cornerRadius: 4.0, style: .continuous)
              .stroke(borderColor, lineWidth: borderWidth))
            .focused($focusField, equals: .textField)
          HStack {
            ZStack {
              Color(.white)
                .cornerRadius(4.0)
                .opacity(placeholderBackgroundOpacity)
              Text(placeholder)
                .foregroundColor(.white)
                .colorMultiply(placeholderColor)
                .animatableFont(size: placeholderFontSize)
                .padding(2.0)
                .layoutPriority(1)
            }
              .padding([.leading], placeholderLeadingPadding)
              .padding([.bottom], placeholderBottomPadding)
            Spacer()
          }
          HStack {
            VStack {
              Spacer()
              Text(hint)
                .font(.system(size: 10.0))
                .foregroundColor(.gray)
                .padding([.leading], 10.0)
            }
            Spacer()
          }
        }
          .onChange(of: editing) {
            focusField = $0 ? .textField : nil
            withAnimation(.easeOut(duration: 0.1)) {
              updateBorder()
              updatePlaceholder()
            }
          }
            .frame(width: .infinity, height: 64.0)
      }
      private let placeholder: String
      @State private var borderColor = Color.gray
      @State private var borderWidth = 1.0
      @Binding private var editing: Bool
      @FocusState private var focusField: Field?
      @Binding private var hint: String
      @State private var placeholderBackgroundOpacity = 0.0
      @State private var placeholderBottomPadding = 0.0
      @State private var placeholderColor = Color.gray
      @State private var placeholderFontSize = 16.0
      @State private var placeholderLeadingPadding = 2.0
      @Binding private var text: String
      @Binding private var valid: Bool

      init(_ text: Binding<String>,
           placeholder: String,
           hint: Binding<String>,
           editing: Binding<Bool>,
           valid: Binding<Bool>) {
        self._text = text
        self.placeholder = placeholder
        self._hint = hint
        self._editing = editing
        self._valid = valid
      }

      private func updateBorder() {
        updateBorderColor()
        updateBorderWidth()
      }

      private func updateBorderColor() {
        if !valid {
          borderColor = .red
          return
        }
        if editing {
          borderColor = .blue
          return
        }
        borderColor = .gray
      }

      private func updateBorderWidth() {
        borderWidth = editing ? 2.0 : 1.0
      }

      private func updatePlaceholder() {
        updatePlaceholderBackground()
        updatePlaceholderColor()
        updatePlaceholderFontSize()
        updatePlaceholderPosition()
      }

      private func updatePlaceholderBackground() {
        if editing || !text.isEmpty {
          placeholderBackgroundOpacity = 1.0
        } else {
          placeholderBackgroundOpacity = 0.0
        }
      }

      private func updatePlaceholderColor() {
        if valid {
          placeholderColor = editing ? .blue : .gray
        } else if text.isEmpty {
          placeholderColor = editing ? .red : .gray
        } else {
          placeholderColor = .red
        }
      }

      private func updatePlaceholderFontSize() {
        if editing || !text.isEmpty {
          placeholderFontSize = 10.0
        } else {
          placeholderFontSize = 16.0
        }
      }

      private func updatePlaceholderPosition() {
        if editing || !text.isEmpty {
                placeholderBottomPadding = 34.0
                placeholderLeadingPadding = 8.0
            } else {
          placeholderBottomPadding = 0.0
          placeholderLeadingPadding = 8.0
        }
      }

      private enum Field {
        case textField
      }

    }

struct MaterialStyleTextFieldExample: View {
    var body: some View {
        VStack {
            MaterialStyleTextField($viewModel.text1,
                                  placeholder: viewModel.placeholder1,
                                  hint: $viewModel.hint1,
                                  editing: $editingTextField1,
                                  valid: $viewModel.text1Valid)
            .padding()
            .onTapGesture { editingTextField1 = true }
            MaterialStyleTextField($viewModel.text2,
                                  placeholder: viewModel.placeholder2,
                                  hint: $viewModel.hint2,
                                  editing: $editingTextField2,
                                  valid: $viewModel.text2Valid)
            .padding()
            .onTapGesture { editingTextField2 = true }
          Spacer()
        }
          .frame(width: 300.0, height: 200.0)
          .contentShape(Rectangle())
          .onTapGesture {
            editingTextField1 = false
            editingTextField2 = false
          }
      }
      @State private var editingTextField1 = false {
        didSet {
          guard editingTextField1 != oldValue else { return }
          if editingTextField1 {
            editingTextField2 = false
          } else {
            viewModel.validateText1()
          }
        }
        }
      @State private var editingTextField2 = false {
        didSet {
          guard editingTextField2 != oldValue else { return }
          if editingTextField2 {
            editingTextField1 = false
          } else {
            viewModel.validateText2()
          }
        }
      }
      @StateObject private var viewModel = MaterialStyleTextFieldViewModel()

}

struct MaterialStyleTextField_Previews: PreviewProvider {
    static var previews: some View {
        MaterialStyleTextFieldExample()
    }
}
