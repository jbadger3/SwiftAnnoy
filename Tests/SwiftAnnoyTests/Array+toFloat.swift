//
//  File 2.swift
//  
//
//  Created by Jonathan Badger on 5/27/20.
//

import Foundation


extension Array where Element: BinaryFloatingPoint{
    func toFloat() -> [Float] {
        return self.map({Float($0)})
    }
}

