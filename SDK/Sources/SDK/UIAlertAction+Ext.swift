//
//  UIAlertAction+Ext.swift
//  App
//
//  Created by ברק בן חור on 29/01/2023.
//

import UIKit

private let swizzling: (UIAlertAction.Type) -> () = { action in
    let originalSelector = #selector(UIAlertAction.init(title:style:handler:))
    let swizzledSelector = #selector(UIAlertAction.swizzled_init(title:style:handler:))
    
    guard let originalMethod = class_getClassMethod(action, originalSelector), let swizzledMethod = class_getClassMethod(action, swizzledSelector) else { return }
    method_exchangeImplementations(originalMethod, swizzledMethod)
}

extension UIAlertAction {
    public class func swizzle() {
        guard self === UIAlertAction.self else {
            return
        }
        swizzling(self)
    }
    
    @objc class func swizzled_init(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> UIAlertAction {
        let myHandler: ((UIAlertAction) -> Swift.Void) = { action in
            NotificationCenter.default.post(name: NSNotification.Name("trackEvent"), object: nil, userInfo: ["event": "tap on popup button: \(self)\naction:\(action.description)"])
            handler?(action)
        }
        
        return swizzled_init(title: title, style: style, handler: myHandler)
    }
}
