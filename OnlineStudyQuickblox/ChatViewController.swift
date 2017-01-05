//
//  ChatViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    var messages: [QBChatMessage] = []
    var dialog: QBChatDialog!
    
    var senderUser: QBUUser!
    var recipientUser: QBUUser!
    
    var recipientUserDisplayName: String {
        return recipientUser.fullName ?? recipientUser.login ?? "\(recipientUser.id)"
    }
    
    var senderUserDisplayName: String {
        return senderUser.fullName ?? senderUser.login ?? "\(senderUser.id)"
    }
    
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.senderId = "\(senderUser.id)"
        self.senderDisplayName = senderUserDisplayName
        
        self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        self.retrieveMessageList()
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatDidReceive(_:)), name: .chatDidReceive, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ChatViewController {
    @objc fileprivate func chatDidReceive(_ notification: Notification) {
        if let message = notification.object as? QBChatMessage {
            if message.dialogID == self.dialog.id {
                self.messages.push(message)
                self.finishReceivingMessage(animated: true)
            }
        }
    }
    
    fileprivate func retrieveMessageList() {
        QBRequest.messages(withDialogID: dialog.id!, successBlock: { (res, messages) in
            self.messages = messages ?? []
            self.finishReceivingMessage()
        }) { (res) in
            if let error = res.error?.error {
                UIAlertController(error: error).show()
            }
        }
    }
}

extension ChatViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        let message = messages[indexPath.row]
        
        let jsqMessage = JSQMessage(
            senderId: "\(message.senderID)",
            senderDisplayName: "\(senderUser.id == message.senderID ? senderUserDisplayName : recipientUserDisplayName)",
            date: message.dateSent!, text: message.text!)
        
        return jsqMessage
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.row]
        
        if senderUser.id == message.senderID {
            return outgoingBubbleImageView
        } else {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.row]
        
        cell.textView.textColor = senderUser.id == message.senderID ? .white : .black
        
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = QBChatMessage()
        message.text = text
        message.dateSent = Date()
        
        self.dialog.send(message, completionBlock: { (error) in
            if let error = error {
                UIAlertController(error: error).show()
            }
        })
        
        self.messages.push(message)
        
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        self.finishSendingMessage()
    }
}
