//
//  File 2.swift
//  
//
//  Created by Jonathan Badger on 5/27/20.
//

func testData() -> [[Double]] {
    let item0 = [1.0, 0.0]
    let item1 = [0.0, 1.0]
    let item2 = [-1.0, 0.0]
    let item3 = [1.0, 1.0]
    let item4 = [4.0, 5.0]
    let item5 = [7.0, 9.0]
    return [item0, item1, item2, item3, item4, item5]
}

func floatTestData() -> [[Float]] {
    var floatData: [[Float]] = []
    for item in testData(){
        floatData.append(item.toFloat())
    }
    return floatData
}
