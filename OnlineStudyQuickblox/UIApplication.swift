//
//  UIApplication.swift
//  QBDemo01
//
//  Created by 默司 on 2016/12/2.
//  Copyright © 2016年 默司. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    var topViewController: UIViewController? {
        guard var topViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        
        while let presentedViewController = topViewController.presentedViewController {
            topViewController = presentedViewController
        }
        return topViewController
    }
    
    var topNavigationController: UINavigationController? {
        return topViewController as? UINavigationController
    }
}
