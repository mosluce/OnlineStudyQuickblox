//
//  UIViewController.swift
//  Gotyou
//
//  Created by 默司 on 2016/12/5.
//  Copyright © 2016年 默司. All rights reserved.
//

import UIKit

protocol StoryBoardInstantiatable {}
extension UIViewController : StoryBoardInstantiatable {}

extension StoryBoardInstantiatable where Self: UIViewController {
    static func instantiate(fromStoryboard storyboard: UIStoryboard = .main) -> Self {
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
}
