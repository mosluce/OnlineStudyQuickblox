//
//  UserConfigViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
import SVProgressHUD

class UserConfigViewController: UIViewController {

    @IBOutlet weak var displayNameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "User Config"
        self.navigationItem.backBarButtonItem?.title = "Log Out"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: Any) {
        
        guard !displayNameField.isEmpty, let displayName = displayNameField.text else {
            return
        }
        
        let params = QBUpdateUserParameters()
        params.fullName = displayName
        
        SVProgressHUD.show()
        QBRequest.updateCurrentUser(params, successBlock: { (res, user) in
            
            SVProgressHUD.dismiss()
            
            // 替換
            var vcs = UINavigationController.default?.viewControllers.filter({ (vc) -> Bool in
                return vc != self
            })
            
            vcs!.push(DialogListViewController.instantiate())
                
            UINavigationController.default?.setViewControllers(vcs!, animated: true)
            
        }) { (res) in
            SVProgressHUD.dismiss()
            
            if let error = res.error?.error {
                UIAlertController(error: error).show()
            }
        }
    }
}
