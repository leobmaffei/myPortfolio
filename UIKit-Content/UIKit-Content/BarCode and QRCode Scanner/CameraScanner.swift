//
//  ViewController.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 25/01/23.
//

import UIKit
import Vision
import AVFoundation
import SafariServices

enum CameraScannerError {
    case barcodeError
    case cameraUsagerPermissionDenied
    case noCameraFound
    case noTorchFound
}

struct ScannedObject {
    let payload: String?
    let confidence: Float
}

protocol CameraScannerView: NSObject {
    func scanCompleted(withError error: CameraScannerError)
    func scanFoundContent(with result: ScannedObject)
}

class CameraScanner: NSObject {
    // MARK: - Init Properties
    private weak var delegate: CameraScannerView?
    private weak var cameraView: UIView?
    private let types: [VNBarcodeSymbology]
    private let videoOrientation: AVCaptureVideoOrientation
    private let minimumConfidence: VNConfidence
    private var torchModeOn: Bool

    // MARK: - Internal Use
    private var captureSession = AVCaptureSession()
    private let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)

    /// Make VNDetectBarcodesRequest variable
    private lazy var detectBarcodeRequest = VNDetectBarcodesRequest { request, error in
        guard error == nil else {
            self.handleError(error: .barcodeError)
            return
        }
        self.processClassification(request)
    }

    // MARK: - init
    init(shouldScanTypes types: [VNBarcodeSymbology],
         delegate: CameraScannerView,
         cameraView: UIView,
         videoOrientation: AVCaptureVideoOrientation = .portrait,
         minimumConfidence: VNConfidence = 0.5,
         torchModeOn: Bool = false) {
        self.delegate = delegate
        self.cameraView = cameraView
        self.types = types
        self.videoOrientation = videoOrientation
        self.minimumConfidence = minimumConfidence
        self.torchModeOn = torchModeOn

        super.init()
        torchLight(on: torchModeOn)
    }

    public func startScanning() {
        checkPermissions()
    }

    public func stopScanning() {
        captureSession.stopRunning()
    }

    public func toggleTorchLight() {
        torchModeOn.toggle()
        torchLight(on: torchModeOn)
    }

    private func torchLight(on: Bool) {
        guard
            let device = videoDevice,
            device.hasTorch else {
            handleError(error: .noTorchFound)
            return
        }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            handleError(error: .noTorchFound)
        }
    }

    private func handleError(error: CameraScannerError) {
        self.delegate?.scanCompleted(withError: error)
    }
}

extension CameraScanner {
    // MARK: - Camera
    private func checkPermissions() {
        /// Cheking for camera usage permission on DevicePremission Handler
        switch DevicePermissionHandler(delegate: nil).getCameraUsagePermission() {
        case .authorized:
            self.setupCameraLiveView()
        default:
            self.handleError(error: .cameraUsagerPermissionDenied)
        }
    }

    private func setupCameraLiveView() {
        // TODO: Setup captureSession
        captureSession.sessionPreset = .high

        // TODO: Add input
        guard
            let device = videoDevice,
            let videoDeviceInput = try? AVCaptureDeviceInput(device: device),
            captureSession.canAddInput(videoDeviceInput) else {
            handleError(error: .noCameraFound)
            return
        }

        captureSession.addInput(videoDeviceInput)

        // TODO: Add output
        let captureOutput = AVCaptureVideoDataOutput()
        // TODO: Set video sample rate
        captureOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        captureOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        captureSession.addOutput(captureOutput)

        configurePreviewLayer()

        // TODO: Run session
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }

    // MARK: - Vision
    private func processClassification(_ request: VNRequest) {
        // TODO: Main logic
        guard let barcodes = request.results else { return }
        DispatchQueue.main.async { [self] in
            if captureSession.isRunning {
                cameraView?.layer.sublayers?.removeSubrange(1...)
                for barcode in barcodes {
                    guard
                        // TODO: Check for Code symbology and confidence score
                        let potentialCode = barcode as? VNBarcodeObservation,
                        types.contains(potentialCode.symbology),
                        potentialCode.confidence > minimumConfidence
                    else { return }
                    observationHandler(payload: potentialCode)
                }
            }
        }
    }

    // MARK: - Handler
    private func observationHandler(payload: VNBarcodeObservation) {
        delegate?.scanFoundContent(with: ScannedObject(payload: payload.payloadStringValue, confidence: payload.confidence))
    }
}

// MARK: - AVCaptureDelegation
extension CameraScanner: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // TODO: Live Vision
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        let imageRequestHandler = VNImageRequestHandler(
            cvPixelBuffer: pixelBuffer,
            orientation: .right)

        do {
            try imageRequestHandler.perform([detectBarcodeRequest])
        } catch {
            print(error)
        }
    }
}

// MARK: - Helper
extension CameraScanner {
    private func configurePreviewLayer() {
       // DispatchQueue.main.async {
            let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            cameraPreviewLayer.videoGravity = .resizeAspectFill
            cameraPreviewLayer.connection?.videoOrientation = self.videoOrientation
            cameraPreviewLayer.frame = self.cameraView?.frame ?? .zero
            self.cameraView?.layer.insertSublayer(cameraPreviewLayer, at: 0)
        //}
    }
}
