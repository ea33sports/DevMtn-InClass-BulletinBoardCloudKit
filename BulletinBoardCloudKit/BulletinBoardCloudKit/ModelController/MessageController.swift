//
//  MessageController.swift
//  BulletinBoardCloudKit
//
//  Created by Eric Andersen on 9/24/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import CloudKit

class MessageController {
    
    static let shared = MessageController()
    var messages: [Message] = [] {
        didSet {
            NotificationCenter.default.post(name: messagesWereUpdatedNotification, object: nil)
        }
    }
    
    // Create Notification
    let messagesWereUpdatedNotification = Notification.Name("MessagesWereUpdated")
    
    
    // CRUD
    func createMessage(text: String) {
        let message = Message(text: text)
        saveMessageToCloudKit(message)
    }
    
    func saveMessageToCloudKit(_ message: Message) {
        
        let record = message.cloudKitRecord
        CKContainer.default().publicCloudDatabase.save(record) { (record, error) in
            
            if let error = error {
                print("There was an error in \(#function); \(error) ; \(error.localizedDescription)")
                return
            }
            
            if let record = record {
                guard let message = Message(ckRecord: record) else { return }
                self.messages.append(message)
            }
        }
    }
    
    func fetchAllMessageRecordsFromCloudKit() {
        
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: Message.TypeKey, predicate: predicate)
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            
            if let error = error {
                print("There was an error in \(#function); \(error); \(error.localizedDescription)")
                return
            }
            
            guard let records = records else { return }
            let messages = records.compactMap{ Message(ckRecord: $0 )}
            self.messages = messages
        }
    }
}
