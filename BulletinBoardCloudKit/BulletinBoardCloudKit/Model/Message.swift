//
//  Message.swift
//  BulletinBoardCloudKit
//
//  Created by Eric Andersen on 9/24/18.
//  Copyright © 2018 Eric Andersen. All rights reserved.
//

import Foundation
import CloudKit

class Message {
    
    static let TypeKey = "Message"
    static let textKey = "Text"
    static let timestampKey = "Timestamp"
    
    let text: String
    let timestamp: Date
    
    // MARK: - CloudKit
    var cloudKitRecord: CKRecord {
        
        let record = CKRecord(recordType: Message.TypeKey)
        
        //This is two different ways to do the exact same thing.
        record.setValue(text, forKey: Message.textKey)
        record[Message.timestampKey] = timestamp as CKRecordValue
        
        return record
    }
    
    init(text: String, timestamp: Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
    
    convenience init?(ckRecord: CKRecord) {
        
        guard let text = ckRecord[Message.textKey] as? String,
              let timestamp = ckRecord[Message.timestampKey] as? Date else { return nil }
        
        self.init(text: text, timestamp: timestamp)
    }
}
