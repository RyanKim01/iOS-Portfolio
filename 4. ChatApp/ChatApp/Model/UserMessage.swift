//
//  Message.swift
//  ChatApp
//
//  Created by Ryan Kim on 7/12/17.
//  Copyright © 2017 RKProduction. All rights reserved.
//

import Foundation

class UserMessage {
    let body: String!
    let isSender: Bool!
    
    init(body: String, isSender: Bool) {
        self.body = body
        self.isSender = isSender
    }
}
