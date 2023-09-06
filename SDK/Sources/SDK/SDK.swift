import Foundation
import UIKit

public class SDK {
    static public let sheard = { return SDK() }()
    private var evant: ((String) -> ())!
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(trackEvent(notifaction:)), name: NSNotification.Name("trackEvent"), object: nil)
    }
    
    public func track(evant: @escaping (String) -> ()) {
        self.evant = evant
        UIViewController.swizzle()
        UIControl.swizzle()
        UIAlertAction.swizzle()
        UIGestureRecognizer.swizzle()
//        UITableView.swizzle()
    }
    
    @objc private func trackEvent(notifaction: Notification) {
        guard let text = notifaction.userInfo?["event"] as? String else { return }
        evant?(text)
    }
}
