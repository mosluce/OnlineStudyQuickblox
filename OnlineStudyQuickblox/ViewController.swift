//
//  ViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/4.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        UINavigationController.default?.setViewControllers([LoginViewController.instantiate()], animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

