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
    private let maxReadLength: Int = 4096
    
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
        
        // add as delegate
        self.inputStream.delegate = self
        
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

// MARK: - StreamDelegate protocol
extension ChatRoom: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.hasBytesAvailable:
            Logger.network.message("hasBytesAvailable")
            
            // try to use the `aStream` as `InputStream`
            if let valid_inputStream: InputStream = aStream as? InputStream {
                self.readAvailableBytes(from: valid_inputStream)
            }
            else {
                Logger.warning.message("`aStream` is not a \(String(describing: InputStream.self))")
            }
            
        case Stream.Event.endEncountered:
            Logger.network.message("endEncountered")
            
        case Stream.Event.errorOccurred:
            Logger.network.message("errorOccurred")
            
        case Stream.Event.hasSpaceAvailable:
            Logger.network.message("hasSpaceAvailable")
            
        case Stream.Event.openCompleted:
            Logger.network.message("openCompleted")
            
        default:
            Logger.network.message("some other event: \(eventCode)")
        }
    }
}

// MARK: - Stream processing
extension ChatRoom {
    
    private func readAvailableBytes(from stream: InputStream) {
        // we need a buffer into which we read the incomming bytes
        let buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: self.maxReadLength)
        
        // we loop for as long there are bytes to be read
        while stream.hasBytesAvailable {
            
            // at each iteration we will read bytes from the stream and put them in the buffer
            let numberOfBytesRead: Int = self.inputStream.read(buffer, maxLength: self.maxReadLength)
            
            // check for negative value
            if numberOfBytesRead < 0 {
                if let error = stream.streamError {
                    Logger.error.message("Error: ").object(error)
                    break
                }
            }
            
            // construct the Message object (if possible)
            if let valid_message: Message = self.processedMessage(from: buffer, length: numberOfBytesRead) {
                
                // notify subscribers (delegates)
            }
        }
    }
    
    private func processedMessage(from buffer: UnsafeMutablePointer<UInt8>, length: Int) -> Message? {
        guard let valid_string: String = String(bytesNoCopy: buffer, length: length, encoding: .ascii, freeWhenDone: true) else {
            Logger.error.message("Unable to create \(String(describing: String.self)) object from buffer")
            return nil
        }
        
        let stringsArray: [String] = valid_string.components(separatedBy: ":")
        
        guard let valid_name: String = stringsArray.first else {
            Logger.error.message("Unable to obtain `name` part")
            return nil
        }
        guard let valid_message: String = stringsArray.last else {
            Logger.error.message("Unable to obtain `message` part")
            return nil
        }
        
        // decide whether this message is ours or not
        let messageSender: MessageSender = (valid_name == self.username) ? .ourself : .someoneElse
        let message: Message = Message(message: valid_message, messageSender: messageSender, username: valid_name)
        return message
    }
}

// MARK: - Errors
extension ChatRoom {
    
    enum ChatRoomError: Error {
        case General(reason: String)
    }
}
