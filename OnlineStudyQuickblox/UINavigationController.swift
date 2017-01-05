//
//  UINavigationController.swift
//  QBDemo01
//
//  Created by 默司 on 2016/12/2.
//  Copyright © 2016年 默司. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    static var `default`: UINavigationController? {
        return UIApplication.shared.topNavigationController
    }
    
    func push<T: UIViewController>(vcClass: T.Type, storyboard: UIStoryboard = .main) {
        self.pushViewController(storyboard.instantiateViewController(withIdentifier: String(describing: vcClass)), animated: true)
    }
}
