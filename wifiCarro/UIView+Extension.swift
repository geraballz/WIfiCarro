//
//  UIView+Extension.swift
//  wifiCarro
//
//  Created by Gerardo Herrera on 24/07/22.
//

import UIKit
import AudioToolbox

extension UIView {
    func addAction(_ selector: Selector, target: AnyObject) {
        isUserInteractionEnabled = true
        let gesture = UILongPressGestureRecognizer(target: target, action: selector)
        gesture.minimumPressDuration = 0.1
        self.addGestureRecognizer(gesture)
    }
    
    func showAnimation(_ completionBlock: @escaping () -> Void) {
      AudioServicesPlayAlertSound(SystemSoundID(1520))
      isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                            self?.transform = CGAffineTransform.init(scaleX: 0.90, y: 0.90)
        }) {  (done) in
            UIView.animate(withDuration: 0.1,
                           delay: 0,
                           options: .curveLinear,
                           animations: { [weak self] in
                                self?.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            }) { [weak self] (_) in
                self?.isUserInteractionEnabled = true
                completionBlock()
            }
        }
    }
}
