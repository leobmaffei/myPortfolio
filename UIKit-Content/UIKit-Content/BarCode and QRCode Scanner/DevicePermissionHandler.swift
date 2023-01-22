//
//  DevicePermissionHandler.swift
//  UIKit-Content
//
//  Created by Sumup on 17/01/23.
//

import AVFoundation

enum CameraPermissionAthorization {
    case deniedCameraPermission
    case authorized
}

class DevicePermissionHandler {
    func getCameraUsagePermission() -> AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

    }

    func validateCameraPermission(completion: @escaping (CameraPermissionAthorization) -> Void ) {
        switch getCameraUsagePermission() {
            /*
             Status Restricted -
             The client is not authorized to access the hardware for the media type. The user cannot change the client's status, possibly due to active restrictions such as parental controls being in place.
             */
        case .denied, .restricted:
            // Denied access to camera
            // Explain that we need camera access and how to change it.
            // "To enable access, go to Settings > Privacy > Camera and turn on Camera access for this app."
            completion(CameraPermissionAthorization.deniedCameraPermission)
        case .notDetermined:
            // The user has not yet been presented with the option to grant access to the camera hardware.
            // Ask for it.
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (grantd) in
               if grantd {
                   completion(CameraPermissionAthorization.authorized)
                }
            })
        case .authorized:
            completion(CameraPermissionAthorization.authorized)
        @unknown default:
            break; //handle other status
        }
    }
}
