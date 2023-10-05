//
//  UIView + extension.swift
//  PetApp
//
//  Created by Artur Imanbaev on 26.09.2023.
//

import Foundation
import UIKit
extension UIView {
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 30
    }

    func doGlowAnimation(withColor color: UIColor, withEffect effect: GlowEffect = .normal) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowRadius = 0
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero

        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 20 // effect.rawValue
        glowAnimation.toValue = 20
        glowAnimation.fillMode = .removed
        glowAnimation.repeatCount = .infinity
        layer.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
