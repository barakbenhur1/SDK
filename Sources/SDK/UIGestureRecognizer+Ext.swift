.sta//
//  UIGestureRecognizer+Ext.swift
//  
//
//  Created by ברק בן חור on 03/09/2023.
//

import UIKit

public protocol TrackbleGesture: AnyObject {}

extension UIGestureRecognizer {
    static func swizzle() {
        if let originalMethod = class_getInstanceMethod(UIGestureRecognizer.self, #selector(UIGestureRecognizer.init(target:action:))),
           let swizzledMethod = class_getInstanceMethod(UIGestureRecognizer.self, #selector(UIGestureRecognizer.swizzled_init(target:action:))) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    private static var _myComputedProperty = [String:Any]()
    
    private var targetProperty:AnyObject? {
        get {
            let tmpAddress = String(format: "%p-targetProperty", unsafeBitCast(self, to: Int.self))
            return UIGestureRecognizer._myComputedProperty[tmpAddress] as AnyObject
        }
        set(newValue) {
            let tmpAddress = String(format: "%p-targetProperty", unsafeBitCast(self, to: Int.self))
            UIGestureRecognizer._myComputedProperty[tmpAddress] = newValue
        }
    }
    
    private var actionProperty:Selector? {
        get {
            let tmpAddress = String(format: "%p-actionProperty", unsafeBitCast(self, to: Int.self))
            return UIGestureRecognizer._myComputedProperty[tmpAddress] as? Selector
        }
        set(newValue) {
            let tmpAddress = String(format: "%p-actionProperty", unsafeBitCast(self, to: Int.self))
            UIGestureRecognizer._myComputedProperty[tmpAddress] = newValue
        }
    }
    
    @discardableResult @objc private func swizzled_init(target: AnyObject?, action: Selector?) -> Selector {
        guard target is TrackbleGesture else { return swizzled_init(target: target, action: action) }
        targetProperty = target
        actionProperty = action
        return swizzled_init(target: self, action:  #selector(swizzled_action))
    }
    
    @objc dynamic func swizzled_action() {
        guard let targetProperty = targetProperty, let actionProperty = actionProperty else { return }
        targetProperty.performSelector(onMainThread: actionProperty, with: self.state, waitUntilDone: false)
        NotificationCenter.default.post(name: NSNotification.Name("trackEvent"), object: nil, userInfo: ["event": "interacted with: \(self.description)"])
    }
}
