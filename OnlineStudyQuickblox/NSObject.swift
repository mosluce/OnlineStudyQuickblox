//
//  NSObject.swift
//  QBDemo01
//
//  Created by 默司 on 2016/12/2.
//  Copyright © 2016年 默司. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
    
    var className: String {
        return type(of: self).className
    }
}
