//
//  CameraScannerViewController.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 17/01/23.
//

import UIKit

// MARK: - Subviews
class CameraScannerViewController: UIViewController {
    private var cameraScanner: CameraScanner?
    private var cameraPermissionHandler: DevicePermissionHandler?
    private var cameraView = UIView()
    private var closeButton: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.setTitle("Close", for: .normal)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 24
        return view
    }()
    private lazy var flashButton: UIButton = {
        let view = UIButton(type: .roundedRect)
        view.setTitle("Flash", for: .normal)
        view.backgroundColor = .blue
        view.layer.cornerRadius = 24
        return view
    }()
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 16
        return view
    }()
    private lazy var vStack = VStack(content: [closeButton, flashButton], distribution: .equalSpacing)

    private func addSubviews() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        flashButton.translatesAutoresizingMaskIntoConstraints = false
        flashButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        flashButton.widthAnchor.constraint(equalToConstant: 48).isActive = true
        self.view.addSubview(cameraView)
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        cameraView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        cameraView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        cameraView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        cameraView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        overlayView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        overlayView.widthAnchor.constraint(equalTo: backgroundView.widthAnchor, multiplier: 0.5).isActive = true
        overlayView.heightAnchor.constraint(equalTo: backgroundView.heightAnchor, multiplier: 0.8).isActive = true
        self.view.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
        vStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        vStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24).isActive = true

        closeButton.transform = closeButton.transform.rotated(by: CGFloat(Double.pi / 2)) //Rotate view 90 degrees
        flashButton.transform = flashButton.transform.rotated(by: CGFloat(Double.pi / 2)) //Rotate view 90 degrees
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundView.overlay(withView: overlayView)
    }
}

// MARK: - View Life Cycle
extension CameraScannerViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.cameraPermissionHandler = DevicePermissionHandler(delegate: self)
        self.cameraScanner = CameraScanner(shouldScanTypes: [.i2of5, .i2of5Checksum],
                                           delegate: self,
                                           cameraView: self.cameraView,
                                           videoOrientation: .portrait,
                                           minimumConfidence: 0.4,
                                           torchModeOn: false)
        self.navigationController?.isNavigationBarHidden = true
        closeButton.addTarget(self, action: #selector(closeAction), for: .touchUpInside)
        flashButton.addTarget(self, action: #selector(flashAction), for: .touchUpInside)
        addSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cameraPermissionHandler?.validateCameraPermission()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraScanner?.stopScanning()
    }
}

// MARK: - Camera Scanner Delegate
extension CameraScannerViewController: CameraScannerView {
    func scanFoundContent(with result: ScannedObject) {
        AlertBuilder(viewController: self)
            .withTitle("Success")
            .andMessage("your code is: \(result.payload ?? "")")
            .preferredStyle(.alert)
            .onSuccessAction(title: "OK", { _ in }).show()
    }

    func scanCompleted(withError error: CameraScannerError) {
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
}

// MARK: - User Input Actions
@objc extension CameraScannerViewController {
    private func closeAction() {
        cameraScanner?.stopScanning()
        self.navigationController?.popViewController(animated: true)
    }

    private func flashAction() {
        cameraScanner?.toggleTorchLight()
    }
}

// MARK: - Camera Permission Delegate
extension CameraScannerViewController: DevicePermissionProtocol {
    func videoPermission(permission: CameraPermissionAthorization) {
        switch permission {
        case .deniedCameraPermission:
            DispatchQueue.main.async {
                AlertBuilder(viewController: self)
                    .withTitle("Permission Needed")
                    .andMessage("Go to permissions and authorise camera usage")
                    .preferredStyle(.alert)
                    .onSuccessAction(title: "Settings", { _ in
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    })
                    .onCancelAction(title: "Cancel", { _ in })
                    .show()
            }
        case .authorized:
            DispatchQueue.main.async { [weak self] in
                self?.cameraScanner?.startScanning()
            }
        }
    }
}
