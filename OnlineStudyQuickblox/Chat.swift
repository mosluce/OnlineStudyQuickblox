//
//  Chat.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

class Chat: NSObject, QBChatDelegate {
    static let shared = Chat()
    
    func config() {
        QBChat.instance().addDelegate(self)
    }
    
    func chatDidConnect() {
        print("=== chatDidConnect ===")
    }
    
    func chatDidReconnect() {
        print("=== chatDidReconnect ===")
    }
    
    func chatDidReceive(_ message: QBChatMessage) {
        print("=== chatDidReceive ===")
        NotificationCenter.default.post(name: .chatDidReceive, object: message)
    }
    
    func chatDidReceiveSystemMessage(_ message: QBChatMessage) {
        print("=== chatDidReceiveSystemMessage ===")
        NotificationCenter.default.post(name: .chatDidReceiveSystemMessage, object: message)
    }
}

extension Notification.Name {
    static let chatDidReceive = Notification.Name(rawValue: "chatDidReceive")
    static let chatDidReceiveSystemMessage = Notification.Name(rawValue: "chatDidReceiveSystemMessage")
}
