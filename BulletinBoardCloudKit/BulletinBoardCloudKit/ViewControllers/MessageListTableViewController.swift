//
//  MessageListTableViewController.swift
//  BulletinBoardCloudKit
//
//  Created by Eric Andersen on 9/24/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import UIKit

class MessageListTableViewController: UITableViewController {
    
    // MARK: - Properties
    let formatter: DateFormatter = {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        return dateFormatter
    }()
    

    // MARK: - IBOutlets
    @IBOutlet weak var messageTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: MessageController.shared.messagesWereUpdatedNotification, object: nil)
        MessageController.shared.fetchAllMessageRecordsFromCloudKit()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MessageController.shared.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
        let message = MessageController.shared.messages[indexPath.row]

        // Configure the cell...
        cell.textLabel?.text = message.text
        cell.detailTextLabel?.text = formatter.string(from: message.timestamp)

        return cell
    }
    
    @objc func updateView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func postMessageButtonTapped(_ sender: UIButton) {
        
        guard let messageText = messageTextField.text, !messageText.isEmpty else { return }
        MessageController.shared.createMessage(text: messageText)
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        tableView.reloadData()
    }
}
