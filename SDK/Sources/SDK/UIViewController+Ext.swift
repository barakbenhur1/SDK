//
//  UIViewController+Ext.swift
//  App
//
//  Created by ברק בן חור on 27/01/2023.
//

import UIKit

extension UIViewController {
    @objc dynamic func _swizzled_viewWillAppear(_ animated: Bool) {
        _swizzled_viewWillAppear(animated)
        NotificationCenter.default.post(name: NSNotification.Name("trackEvent"), object: nil, userInfo: ["event": "open screen: \(self.description)"])
    }
    
    static func swizzle() {
        let selector1 = #selector(UIViewController.viewWillAppear(_:))
        let selector2 = #selector(UIViewController._swizzled_viewWillAppear(_:))
        let originalMethod = class_getInstanceMethod(UIViewController.self, selector1)!
        let swizzleMethod = class_getInstanceMethod(UIViewController.self, selector2)!
        method_exchangeImplementations(originalMethod, swizzleMethod)
    }
}
