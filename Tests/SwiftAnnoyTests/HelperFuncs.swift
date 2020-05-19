//
//  File.swift
//  
//
//  Created by Jonathan Badger on 5/18/20.
//

import Foundation
import XCTest

func assertVecsEqual<T: Numeric>(vec1: [T], vec2: [T]) {
    for (val1, val2) in zip(vec1, vec2) {
        if T.self is Float.Type {
            XCTAssertEqual(val1 as! Float , val2 as! Float , accuracy: Float(0.000001))
        }
    }
}
