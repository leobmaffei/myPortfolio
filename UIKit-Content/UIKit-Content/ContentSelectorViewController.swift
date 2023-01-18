//
//  ContentSelectorViewController.swift
//  UIKit-Content
//
//  Created by Sumup on 11/09/22.
//

import Foundation
import UIKit

class ContentSelectorViewController: UITableViewController {

    var contents = ["Open Web/HTML content page",
                    "Pluggy Connect Webview",
                    "Textfield mask",
                    "Barcode Scanner"]
    var detail = ["Open a webview site or local HTML page with WkWebKit",
                  "Connect with pluggy.ai open banking",
                  "Apply a mask into a text",
                  "Scans Barcode and also QRCode using device camera"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "UIKit"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // attempt to dequeue a cell
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "Cell")

        if cell == nil {
            // none to dequeue – make a new one
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell?.accessoryType = .disclosureIndicator
        }

        cell.detailTextLabel?.text = detail[indexPath.row]
        cell.textLabel?.text = contents[indexPath.row]

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let detail = WebContentViewController()
            navigationController?.pushViewController(detail, animated: true)
        } else if indexPath.row == 2 {
            let view = TextfieldFormatterViewController()
            navigationController?.pushViewController(view, animated: true)
        } else if indexPath.row == 3 {
            let view = CameraScannerViewController()
            navigationController?.pushViewController(view, animated: true)
        }
    }
}
