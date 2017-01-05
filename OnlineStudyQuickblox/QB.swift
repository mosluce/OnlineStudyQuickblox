//
//  QBRequest.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
import SVProgressHUD

class QB: NSObject {
    
    static func logInSync(withUserLogin login: String, password: String) throws -> QBUUser {
        let semaphore = DispatchSemaphore(value: 0)
        
        var error: Error?
        var uuser: QBUUser?
        
        QBRequest.logIn(withUserLogin: login, password: password, successBlock: { (res, user) in
            uuser = user
            
            semaphore.signal()
        }) { (res) in
            //TODO: 處理ERROR
            error = res.error?.error
            
            semaphore.signal()
        }
        
        SVProgressHUD.show(withStatus: "logging in")
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        SVProgressHUD.dismiss()
        
        if let error = error {
            throw error
        }
        
        return uuser!
    }
    
    static func signUpSync(withUserLogin login: String, password: String) throws -> QBUUser {
        let semaphore = DispatchSemaphore(value: 0)
        
        var err: Error?
        var uuser = QBUUser()
        uuser.login = login
        uuser.password = password
        
        QBRequest.signUp(uuser, successBlock: { (res, user) in
            do {
                uuser = try QB.logInSync(withUserLogin: login, password: password)
            } catch {
                err = error
            }
            
            semaphore.signal()
        }) { (res) in
            //TODO: 處理ERROR
            err = res.error?.error
            
            semaphore.signal()
        }
        
        SVProgressHUD.show(withStatus: "registering")
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        SVProgressHUD.dismiss()
        
        if let error = err {
            throw error
        }
        
        return uuser
    }
    
    static func connectToChatService(user: QBUUser) throws -> Void {
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var error: Error?
        
        QBChat.instance().connect(with: user) { (err) in
            error = err
            
            semaphore.signal()
        }
        
        SVProgressHUD.show(withStatus: "connecting to chat service")
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        SVProgressHUD.dismiss()
        
        if let error = error {
            // TODO: 處理 Error
            throw error
        }
    }
    
    static func user(withLogin login: String) throws -> QBUUser {
        let semaphore = DispatchSemaphore(value: 0)
        
        var error: Error?
        var uuser: QBUUser?
        
        QBRequest.user(withLogin: login, successBlock: { (req, user) in
            uuser = user
            
            semaphore.signal()
        }) { (res) in
            //TODO: 處理ERROR
            error = res.error?.error
            
            semaphore.signal()
        }
        
        SVProgressHUD.show(withStatus: "geting user id")
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        SVProgressHUD.dismiss()
        
        if let error = error {
            throw error
        }
        
        return uuser!
    }
    
    static func createDialog(withOccupantIDs occupantIDs: [NSNumber]) throws -> QBChatDialog {
        let dialog = QBChatDialog(dialogID: nil, type: .private)
        dialog.occupantIDs = occupantIDs
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var error: Error?
        var qcdialog: QBChatDialog?
        
        QBRequest.createDialog(dialog, successBlock: { (res, dialog) in
            qcdialog = dialog
            
            semaphore.signal()
        }) { (res) in
            //TODO: 處理ERROR
            error = res.error?.error
            
            semaphore.signal()
        }
        
        SVProgressHUD.show(withStatus: "creating dialog")
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        SVProgressHUD.dismiss()
        
        
        if let error = error {
            throw error
        }
        
        return qcdialog!
    }
}
