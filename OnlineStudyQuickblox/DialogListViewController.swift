//
//  DialogListViewController.swift
//  OnlineStudyQuickblox
//
//  Created by 默司 on 2017/1/5.
//  Copyright © 2017年 默司. All rights reserved.
//

import UIKit
import SVProgressHUD

class DialogListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dialogs: [QBChatDialog]? = []
    var dialogIds: Set<NSNumber>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Dialogs"
        self.navigationItem.backBarButtonItem?.title = "Log Out"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectUserToCreateDialog(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.retrieveDialogList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DialogListViewController {
    fileprivate func retrieveDialogList() {
        QBRequest.dialogs(successBlock: { (res, dialogs, dialogIds) in
            self.dialogs = dialogs
            self.dialogIds = dialogIds
            
            if dialogs?.count ?? 0 > 0 {
                self.tableView.reloadData()
                
                return
            }
            
            let alert = UIAlertController(title: "NO RESULT", message: "Can't find any dialog, create it?", preferredStyle: .alert)
            alert.addAction(title: "No, Thanks")
            alert.addAction(title: "Create", style: .default, handler: { (_) in
                self.selectUserToCreateDialog(self)
            })
            alert.show()
        }) { (res) in
            if let error = res.error?.error {
                UIAlertController(error: error).show()
            }
        }
    }
    
    @objc fileprivate func selectUserToCreateDialog(_ sender: Any) {
        let alert = UIAlertController(title: "INPUT", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (field) in
            field.placeholder = "Input a username"
        }
        
        alert.addAction(title: "Cancel")
        alert.addAction(title: "Create", style: .default, isEnabled: true) { (action) in
            if let field = alert.textFields?.first, !field.isEmpty {
                self.createDialog(withLogin: field.text!)
            }
        }
        
        alert.show()
    }
    
    fileprivate func createDialog(withLogin login: String) {
        SVProgressHUD.show(withStatus: "creating dialog")
        
        DispatchQueue.global().async {
            do {
                let to = try QB.user(withLogin: login)
                
                let dialog = try QB.createDialog(withOccupantIDs: [NSNumber(value: to.id)])
                
                DispatchQueue.main.async {
                    self.presentDialogViewController(withDialog: dialog)
                }
                
            } catch {
                UIAlertController(error: error).show()
            }
        }
    }
    
    fileprivate func presentDialogViewController(withDialog dialog: QBChatDialog) {
        let vc = DialogViewController.instantiate()
        
        vc.dialog = dialog
        
        UINavigationController.default?.pushViewController(vc, animated: true)
    }
}

extension DialogListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dialogs?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogCell")!
        
        cell.textLabel?.text = dialogs![indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dialog = dialogs![indexPath.row]
        
        self.presentDialogViewController(withDialog: dialog)
    }
}
