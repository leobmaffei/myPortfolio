//
//  CustomOverlayView.swift
//  UIKit-Content
//
//  Created by Leonardo Maffei on 07/02/23.
//

import UIKit

extension UIView {
    func overlay(withView overlayView: UIView) {
        let cornerRadius = overlayView.layer.cornerRadius
        // Create the initial layer from the view bounds
        let entireViewPath = UIBezierPath(rect: self.bounds)
        // Get the overlay view frame and calculate the overlay path with corner radius
        let overlayViewPath = overlayView.frame
        let roundedRectPath = UIBezierPath(roundedRect: overlayViewPath, byRoundingCorners:.allCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        entireViewPath.append(roundedRectPath)
        entireViewPath.usesEvenOddFillRule = true
        // apply the path to final mask
        let maskLayer = CAShapeLayer()
        maskLayer.path = entireViewPath.cgPath
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        layer.mask = maskLayer
    }
}
