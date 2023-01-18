//
//  WebContentViewController.swift
//  UIKit-Content
//
//  Created by Sumup on 11/09/22.
//

import UIKit
import WebKit

class WebContentViewController: UIViewController, WKNavigationDelegate {

    lazy var webView: WKWebView = {
        let view = WKWebView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var activityView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func layoutContraints() {
        self.view.addSubview(webView)
        self.view.addSubview(activityView)
        let constraints = [webView.topAnchor.constraint(equalTo: self.view.topAnchor),
                           webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                           webView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
                           webView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
                           activityView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                           activityView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)]
        NSLayoutConstraint.activate(constraints)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Open Web & HTML webview"
        view.backgroundColor = .systemBackground

        // reads webview page title changes
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.title), options: .new, context: nil)

        // monitoring page loads
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)

        webView.navigationDelegate = self

        guard let filePath = Bundle.main.path(forResource: "index", ofType: "html") else { return }
        let baseUrl = URL(fileURLWithPath: filePath)
        webView.load(URLRequest(url: baseUrl))

        layoutContraints()
        showActivityIndicatory()
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if Float(webView.estimatedProgress) >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.activityView.stopAnimating()
                 }
            }
        }
    }

    func showActivityIndicatory() {
        activityView.hidesWhenStopped = true
        activityView.startAnimating()
    }
}
