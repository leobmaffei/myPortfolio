//
//  DevicePermissionHandler.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 17/01/23.
//

import AVFoundation

enum CameraPermissionAthorization {
    case deniedCameraPermission
    case authorized
}

protocol DevicePermissionProtocol: NSObject {
    func videoPermission(permission: CameraPermissionAthorization)
}

class DevicePermissionHandler {
    private weak var delegate: DevicePermissionProtocol?

    init(delegate: DevicePermissionProtocol?) {
        self.delegate = delegate
    }

    func getCameraUsagePermission() -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)

    }

    func validateCameraPermission() {
        switch getCameraUsagePermission() {
            /*
             Status Restricted -
             The client is not authorized to access the hardware for the media type. The user cannot change the client's status, possibly due to active restrictions such as parental controls being in place.
             */
        case .denied, .restricted:
            // Denied access to camera
            // Explain that we need camera access and how to change it.
            // "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
            delegate?.videoPermission(permission: .deniedCameraPermission)
        case .notDetermined:
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for it.
            AVCaptureDevice.requestAccess(for: .video) { [self] grantd in
               if grantd {
                   delegate?.videoPermission(permission: .authorized)
               } else {
                   delegate?.videoPermission(permission: .deniedCameraPermission)
               }
            }
        case .authorized:
            delegate?.videoPermission(permission: .authorized)
        @unknown default:
            break; //handle other status
        }
    }
}
