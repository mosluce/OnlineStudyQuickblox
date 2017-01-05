//
//  DialogViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
//import Chatto
//import ChattoAdditions
//import NoChat

class DialogViewController: UIViewController {
    
    @IBOutlet weak var messageField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var dialog: QBChatDialog!
    var messages: [QBChatMessage]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = self.dialog.name
        
        NotificationCenter.default.addObserver(self, selector: #selector(chatDidReceive(_:)), name: .chatDidReceive, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func send(_ sender: Any) {
        if !messageField.isEmpty, let text = messageField.text {
            let message = QBChatMessage()
            message.text = text
            message.dateSent = Date()
            
            dialog.send(message, completionBlock: { (error) in
                if let error = error {
                    UIAlertController(error: error).show()
                }
            })
            
            self.messages.push(message)
            self.scrollToLast()
            self.messageField.text = nil
        }
    }
}

extension DialogViewController {
    fileprivate func retrieveMessageList() {
        QBRequest.messages(withDialogID: dialog.id!, successBlock: { (res, messages) in
            self.messages = messages ?? []
            self.tableView.reloadData({
                self.tableView.scrollToBottom(animated: true)
            })
        }) { (res) in
            if let error = res.error?.error {
                UIAlertController(error: error).show()
            }
        }
    }
    
    @objc fileprivate func chatDidReceive(_ notification: Notification) {
        if let message = notification.object as? QBChatMessage {
            if message.dialogID == self.dialog.id {
                self.messages.push(message)
                self.scrollToLast()
            }
        }
    }
    
    func scrollToLast() {
        let ip = IndexPath(row: self.messages.count - 1, section: 0)
        
        self.tableView.insertRows(at: [ip], with: .none)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.tableView.scrollToRow(at: ip, at: .bottom, animated: true)
        })
    }
}

extension DialogViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")
        let message = messages[indexPath.row]
        let df = DateFormatter()
        
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        cell?.textLabel?.text = message.text
        cell?.detailTextLabel?.text = "from \(message.senderID) at \(df.string(from: message.dateSent!))"
        
        return cell!
    }
}
