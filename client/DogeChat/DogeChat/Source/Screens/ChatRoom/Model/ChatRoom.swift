//
//  ChatRoom.swift
//  DogeChat
//
//  Created by boyankov on W42 19/Oct/2017 Thu.
//  Copyright © 2017 boyankov@yahoo.com. All rights reserved.
//

import UIKit
import SimpleLogger

class ChatRoom: NSObject {

    // MARK: - Properties
    var inputStream: InputStream!
    var outputStream: OutputStream!
    var username: String = ""
    let maxReadLength: UInt = 4096
    
    // MARK: - Initialization
    override init() {
        super.init()
    }
    
    deinit {
        Logger.debug.message("\(String(describing: ChatRoom.self)) deinitialized!")
    }
}

// MARK: - Network setup
extension ChatRoom {

    func setupNetworkCommunication() throws {
        // socket streams
        // they won't be automatically memory menaged
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        // binding socket streams together and connecting to server
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           AppConstants.ServerDetails.host,
                                           AppConstants.ServerDetails.port,
                                           &readStream,
                                           &writeStream)
    
        try self.storeRetainedReferences(for: readStream, and: writeStream)
        try self.addStreamsPairToRunLoop(self.inputStream, self.outputStream)
        try self.openStreamsPair(self.inputStream, self.outputStream)
    }
    
    fileprivate func storeRetainedReferences(for readStream: Unmanaged<CFReadStream>?, and writeStream: Unmanaged<CFWriteStream>?) throws {
        guard let valid_readStream: Unmanaged<CFReadStream> = readStream else {
            let errorMessage: String = "Invalid \(String(describing: CFReadStream.self))"
            Logger.error.message(errorMessage)
            throw ChatRoom.ChatRoomError.General(reason: errorMessage)
        }
        guard let valid_writeStream: Unmanaged<CFWriteStream> = writeStream else {
            let errorMessage: String = "Invalid \(String(describing: CFWriteStream.self))"
            Logger.error.message(errorMessage)
            throw ChatRoom.ChatRoomError.General(reason: errorMessage)
        }
        
        // storing retained references
        self.inputStream = valid_readStream.takeRetainedValue()
        self.outputStream = valid_writeStream.takeRetainedValue()
    }
    
    fileprivate func addStreamsPairToRunLoop(_ inputStream: InputStream?, _ outputStream: OutputStream?) throws {
        try self.addToRunLoop(inputStream)
        try self.addToRunLoop(outputStream)
    }
    
    private func addToRunLoop(_ stream: Stream?) throws {
        let valid_stream: Stream = try self.valid(stream)
        valid_stream.schedule(in: .current, forMode: .commonModes)
    }
    
    fileprivate func openStreamsPair(_ inputStream: InputStream?, _ outputStream: OutputStream?) throws {
        try self.open(inputStream)
        try self.open(outputStream)
    }
    
    private func open(_ stream: Stream?) throws {
        let valid_stream: Stream = try self.valid(stream)
        valid_stream.open()
    }
    
    private func valid(_ stream: Stream?) throws -> Stream {
        guard let valid_stream: Stream = stream else {
            let errorMessage: String = "Invalid \(String(describing: Stream.self)) object!"
            Logger.error.message(errorMessage)
            throw ChatRoom.ChatRoomError.General(reason: errorMessage)
        }
        return valid_stream
    }
}

// MARK: - Joining a chat
extension ChatRoom {
    
    func joinChat(with username: String) throws {
        // constructing the message for chatroom protocol
        guard let valid_data: Data = "iam:\(username)".data(using: .ascii) else {
            let errorMessage: String = "Unable to construct \(String(describing: Data.self)) object!"
            Logger.error.message(errorMessage)
            throw ChatRoom.ChatRoomError.General(reason: errorMessage)
        }
        
        // save username for next messages that will gonna be passed
        self.username = username
        
        // write message to `outputStream`
        _ = valid_data.withUnsafeBytes({ (pointer: UnsafePointer<UInt8>) -> Void in
            self.outputStream.write(pointer, maxLength: valid_data.count)
        })
    }
}

// MARK: - Errors
extension ChatRoom {
    
    enum ChatRoomError: Error {
        case General(reason: String)
    }
}
