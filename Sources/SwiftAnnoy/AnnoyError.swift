//
//  File.swift
//  
//
//  Created by Jonathan Badger on 5/19/20.
//

import Foundation

public enum AnnoyIndexError: Error, LocalizedError {
    case invalidVectorLength(message: String)
    case addItemFailed
    case saveFailed
    case mismatchedArrayLength(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .invalidVectorLength(let message):
            return message
        case .addItemFailed:
            return "Adding item to index failed."
        case .saveFailed:
            return nil //Errors should be printed to stdout by Annoy C++ lib
        case .mismatchedArrayLength(let message):
            return message
        }
    }
}
