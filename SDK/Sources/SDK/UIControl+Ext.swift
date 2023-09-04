//
//  UIButton+EXT.swift
//  App
//
//  Created by ברק בן חור on 27/01/2023.
//

import UIKit

extension UIControl {
    static func swizzle() {
        if let originalMethod = class_getInstanceMethod(UIControl.self, #selector(sendAction(_:to:for:))),
           let swizzledMethod = class_getInstanceMethod(UIControl.self, #selector(swizzled_sendAction)) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc func swizzled_sendAction(_ action: Selector,
                                   to target: Any?,
                                   for event: UIEvent?) {
        swizzled_sendAction(action, to: target, for: event)
        NotificationCenter.default.post(name: NSNotification.Name("trackEvent"), object: nil, userInfo: ["event": "interacted with: \(self.description.description)\naction: \(action.description)\nevent: \(event?.description ?? "no info")"])
    }
}
