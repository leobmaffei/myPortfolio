//
//  BarCodeScanner.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 17/01/23.
//

/// This code is a variant and use Programmingwithswift QRCodeReader as example.
/// For more information you can acess the original code in this repo: https://github.com/programmingwithswift/QRCodeReader
///
/// This Class make it Possible to Read QRCode and Barcode images using the device camera
import UIKit
import AVFoundation

/// ScannerDelegate: Resposible to handle the callback after a scanner reading
protocol ScannerDelegate: NSObject {
    func cameraView() -> UIView
    func delegateViewController() -> UIViewController
    func scanCompleted(withCode code: String)
    func scanCompleted(withError error: CameraScannerErrorType)
}

enum CameraScannerErrorType {
    case noCameraDetectedOnDevice
    case cameraPermissionNotGranted
}

class Scanner: NSObject {
    public weak var delegate: ScannerDelegate?
    private var captureSession : AVCaptureSession?
    private var devicePermissionHandler = DevicePermissionHandler()

    init(withDelegate delegate: ScannerDelegate) {
        self.delegate = delegate
        super.init()
        //devicePermissionHandler.cameraDelegate = self
        //devicePermissionHandler.validateCameraPermission()
    }

    private func scannerSetup() {
        guard let captureSession = self.createCaptureSession() else {
            return
        }

        self.captureSession = captureSession

        guard let delegate = self.delegate else {
            return
        }

        let cameraView = delegate.cameraView()
        let previewLayer = self.createPreviewLayer(withCaptureSession: captureSession,
                                                   view: cameraView)
        cameraView.layer.addSublayer(previewLayer)
    }

    private func createCaptureSession() -> AVCaptureSession? {
        do {
            let captureSession = AVCaptureSession()
            guard let captureDevice = AVCaptureDevice.default(for: .video) else {
                handleNoCameraDetectedError()
                return nil
            }

            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()

            // Add device input
            if captureSession.canAddInput(deviceInput) && captureSession.canAddOutput(metaDataOutput) {
                captureSession.addInput(deviceInput)
                captureSession.addOutput(metaDataOutput)

                guard let delegate = self.delegate,
                      let viewController = delegate.delegateViewController() as? AVCaptureMetadataOutputObjectsDelegate else {
                    return nil
                }

                metaDataOutput.setMetadataObjectsDelegate(viewController,
                                                          queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = self.metaObjectTypes()

                return captureSession
            }
        }
        catch {
            print("error")
            // Handle error
        }

        return nil
    }

    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession,
                                    view: UIView) -> AVCaptureVideoPreviewLayer
    {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill

        return previewLayer
    }

    private func metaObjectTypes() -> [AVMetadataObject.ObjectType]
    {
        return [.qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce
        ]
    }

    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                               didOutput metadataObjects: [AVMetadataObject],
                               from connection: AVCaptureConnection)
    {
        self.requestCaptureSessionStopRunning()

        guard let metadataObject = metadataObjects.first,
              let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
              let scannedValue = readableObject.stringValue,
              let delegate = self.delegate else {
            return
        }

        delegate.scanCompleted(withCode: scannedValue)
    }

    public func requestCaptureSessionStartRunning()
    {
        self.toggleCaptureSessionRunningState()
    }

    public func requestCaptureSessionStopRunning()
    {
        self.toggleCaptureSessionRunningState()
    }

    private func toggleCaptureSessionRunningState() {
        guard let captureSession = self.captureSession else {
            return
        }

        if !captureSession.isRunning {
            captureSession.startRunning()
        } else {
            captureSession.stopRunning()
        }
    }

    private func handleNoCameraDetectedError() {
        delegate?.scanCompleted(withError: .noCameraDetectedOnDevice)
    }

    private func handleCameraPermissionError() {
        delegate?.scanCompleted(withError: .cameraPermissionNotGranted)
    }
}

extension Scanner: CameraPermissionDelegate {
    func deniedCameraPermission() {
        handleCameraPermissionError()
    }

    func authorized() {
        scannerSetup()
    }
}
