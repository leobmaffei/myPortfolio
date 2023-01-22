//
//  CameraScannerViewController.swift
//  UIKit-Content
//
//  Created by Sumup on 17/01/23.
//

import UIKit
import AVFoundation

class CameraScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, ScannerDelegate {
    private var scanner: Scanner?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scanner = Scanner(withDelegate: self)

        startScanning()
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark - AVFoundation delegate methods
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection) {
        guard let scanner = self.scanner else {
            return
        }
        scanner.metadataOutput(output,
                               didOutput: metadataObjects,
                               from: connection)
    }

    // Mark - Scanner delegate methods
    func cameraView() -> UIView {
        return self.view
    }

    func delegateViewController() -> UIViewController {
        return self
    }

    func scanCompleted(withCode code: String) {
        print(code)
    }

    func scanCompleted(withError error: CameraScannerErrorType) {
        DispatchQueue.main.async {
            AlertBuilder(viewController: self)
                .withTitle("No camera found")
                .andMessage("this device dont have camera suport")
                .preferredStyle(.alert)
                .onSuccessAction(title: "OK", { _ in
                    self.navigationController?.popViewController(animated: true)
                }).show()
        }
    }

    func startScanning() {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let scanner = self.scanner else {
                return
            }
            scanner.requestCaptureSessionStartRunning()
        }
    }
}
