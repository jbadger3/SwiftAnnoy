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
    case buildFailed
    case unbuildFailed
    case saveFailed
    case loadFailed
    
    public var errorDescription: String? {
        switch self {
        case .invalidVectorLength(let message):
            return message
        case .addItemFailed:
            return "Adding item to index failed."
        case .buildFailed:
            return nil
        case .unbuildFailed:
            return nil
        case .saveFailed:
            return nil //Errors should be printed to stdout by Annoy C++ lib
        case .loadFailed:
            return nil
        }
    }
}
