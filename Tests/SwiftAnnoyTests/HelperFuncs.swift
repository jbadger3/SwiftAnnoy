//
//  File.swift
//  
//
//  Created by Jonathan Badger on 5/18/20.
//

import XCTest

func assertVecsEqual<T: Numeric>(vec1: [T], vec2: [T]) {
    for (val1, val2) in zip(vec1, vec2) {
        switch T.self {
        case is Float.Type:
            XCTAssertEqual(val1 as! Float , val2 as! Float , accuracy: Float(0.000001))
        case is Double.Type:
            XCTAssertEqual(val1 as! Double, val2 as! Double, accuracy: Double(0.0000001))
        case is Int.Type:
            XCTAssertEqual(val1 , val2)
        default:
            XCTFail()
        }
    }
}
