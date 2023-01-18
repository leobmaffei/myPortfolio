//
//  Alert.swift
//  UIKit-Content
//
//  Created by Sumup on 17/01/23.
//

import UIKit

class Alert {
    private var alert = UIAlertController()

    func create() -> UIAlertController {
        alert
    }

    func title(title: String,
               message: String,
               style: UIAlertController.Style = UIAlertController.Style.alert) -> Alert  {
        alert = UIAlertController(title: title,
                          message: message,
                          preferredStyle: style)
        return self
    }

    func withAction(title: String,
                    style: UIAlertAction.Style = UIAlertAction.Style.default,
                    action: ((UIAlertAction) -> Void)?) -> Alert {
        alert.addAction(UIAlertAction(title: title, style: style, handler: action))
        return self
    }
}
