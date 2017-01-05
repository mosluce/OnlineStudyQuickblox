//
//  LoginViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var accountField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Log In"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.accountField.text = nil
        self.passwordField.text = nil
    }
    
    @IBAction func logIn(_ sender: Any) {
        if !accountField.isEmpty && !passwordField.isEmpty {
            let login = accountField.text!
            let password = passwordField.text!
            
            DispatchQueue.global().async {
                do {
                    let user = try QB.logInSync(withUserLogin: login, password: password)
                    
                    user.password = password
                    
                    try QB.connectToChatService(user: user)
                    
                    DispatchQueue.main.async {
                        self.didLoginSuccess(user: user)
                    }
                    
                } catch {
                    UIAlertController(error: error).show()
                }
            }
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        if !accountField.isEmpty && !passwordField.isEmpty {
            let login = accountField.text!
            let password = passwordField.text!
            
            DispatchQueue.global().async {
                do {
                    let user = try QB.signUpSync(withUserLogin: login, password: password)
                    
                    user.password = password
                    
                    try QB.connectToChatService(user: user)
                    
                    DispatchQueue.main.async {
                        self.didLoginSuccess(user: user)
                    }
                } catch {
                    UIAlertController(error: error).show()
                }
            }
        }
    }
    
}

extension LoginViewController {
    func didLoginSuccess(user: QBUUser) {
        if user.fullName != nil {
            self.presentDialogListViewController()
        } else {
            self.presentUserConfigViewController()
        }
    }
    
    func presentDialogListViewController() {
        UINavigationController.default?.push(vcClass: DialogListViewController.self)
    }
    
    func presentUserConfigViewController() {
        UINavigationController.default?.push(vcClass: UserConfigViewController.self)
    }
}
