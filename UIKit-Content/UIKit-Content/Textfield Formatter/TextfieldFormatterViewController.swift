//
//  TextfieldFormatterViewController.swift
//  UIKit-Content
//
//  Created by Sumup on 02/12/22.
//

import UIKit

class TextfieldFormatterViewController: UIViewController {

    lazy var textfield: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "+55 (00) 99999-9999"
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        loadContraints()
    }

    private func loadContraints() {
        self.view.addSubview(textfield)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textfield.heightAnchor.constraint(equalToConstant: 45).isActive = true
        textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textfield.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}

extension TextfieldFormatterViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text as NSString? {
            let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
            textfield.text = txtAfterUpdate.format(with: "+XX (XX) XXXXX-XXXX")
        }
        return false
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
