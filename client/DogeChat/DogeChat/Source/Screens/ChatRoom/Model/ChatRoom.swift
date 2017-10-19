//
//  ChatRoom.swift
//  DogeChat
//
//  Created by boyankov on W42 19/Oct/2017 Thu.
//  Copyright © 2017 boyankov@yahoo.com. All rights reserved.
//

import UIKit

class ChatRoom: NSObject {

    // MARK: - Properties
    var inputStream: InputStream!
    var outputStream: OutputStream!
    var username: String = ""
    let maxReadLength: UInt = 4096
    
}
