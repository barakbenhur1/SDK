//
//  UITableView+Ext.swift
//  
//
//  Created by ברק בן חור on 04/09/2023.
//

import UIKit

extension UITableView {
    static func swizzle() {
        if let originalMethod = class_getInstanceMethod(UITableViewDelegate.self, #selector(UITableViewDelegate.tableView(_:willDisplay:forRowAt:))),
           let swizzledMethod = class_getInstanceMethod(UITableView.self, #selector(UITableView.swizzled_willDisplay(talbeView:willDisplay:forRowAt:))) {
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc private func swizzled_willDisplay(talbeView: UITableView, willDisplay: UITableViewCell, forRowAt: IndexPath) {
        swizzled_willDisplay(talbeView: talbeView, willDisplay: willDisplay, forRowAt: forRowAt)
        print(talbeView, willDisplay, forRowAt)
    }
}
