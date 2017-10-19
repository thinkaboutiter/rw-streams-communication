//
//  AppConstants.swift
//  DogeChat
//
//  Created by boyankov on W42 19/Oct/2017 Thu.
//  Copyright © 2017 boyankov@yahoo.com. All rights reserved.
//

import Foundation

struct AppConstants {
    
    /**
     // implement if app start using storyboards
     
     // MARK: - Storyboard names
     struct StoryboardName {

     }
     */
    
    struct ServerDetails {
        static let host: CFString = "localhost" as CFString
        static let port: UInt32 = 80
    }
    
    // MARK: - Error messages
    struct ErrorMessage {
        static let generic: String = NSLocalizedString("Something went wrong!", comment: AppConstants.LocalizedStringComment.errorMessage)
        
        /*
         network
         */
        static let unableToParseData: String = NSLocalizedString("Unable to parse data!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResultObject: String = NSLocalizedString("Invalid result object!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResponseObject: String = NSLocalizedString("Invalid response object!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidResourcesReceived: String = NSLocalizedString("Invalid resources received!", comment: AppConstants.LocalizedStringComment.errorMessage)
        static let invalidStatusCode: String = NSLocalizedString("Invalid status code!", comment: AppConstants.LocalizedStringComment.errorMessage)
    }
    
    // MARK: - Localized strings comments
    struct LocalizedStringComment {
        static let errorMessage: String = "Error message"
    }
}
