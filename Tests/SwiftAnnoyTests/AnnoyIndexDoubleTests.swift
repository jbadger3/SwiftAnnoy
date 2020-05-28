//
//  File.swift
//  
//
//  Created by Jonathan Badger on 5/20/20.
//

import XCTest
@testable import SwiftAnnoy

final class AnnoyIndexDoubleTests: XCTestCase {
    typealias DistanceMetric = AnnoyIndex<Double>.DistanceMetric
    
    var sut:AnnoyIndex<Double>!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Given
    func givenTestData() {
        var data = testData()
        for (index, _) in data.enumerated() {
            try! sut.addItem(index: index, vector: &data[index])
        }
    }
    
    func givenIndex(itemLength: Int = 2, metric: DistanceMetric = DistanceMetric.euclidean) {
        sut = AnnoyIndex<Double>(itemLength: itemLength, metric: metric)
    }

    func test_addItem_updatesNumItems() {
        // Given
        givenIndex()
        var item = [1.0, 1.0]
        
        // When
        try! sut.addItem(index: 0, vector: &item)
        
        // Then
        XCTAssertEqual(sut.numberOfItems, 1)
        
        // When
        try! sut.addItem(index: 1, vector: &item)
        
        // Then
        XCTAssertEqual(sut.numberOfItems, 2)
    }
    
    func test_addItem_whenOverwritingOldIndex_UpdatesStoredItem() {
        // Given
        givenIndex()
        var item = [1.0, 1.0]
        try! sut.addItem(index: 0, vector: &item)
        let itemBack = sut.getItem(index: 0)
        assertVecsEqual(vec1: item, vec2: itemBack!)
        
        // When
        var item2 = [2.0, 1.0]
        try! sut.addItem(index: 0, vector: &item2)
        
        // Then
        let itemBack2 = sut.getItem(index: 0)
        assertVecsEqual(vec1: item2, vec2: itemBack2!)
    }
    
    func test_addItem_whenWrongVectorLength_throwsInvalidVectorSizeError() {
        // Given
        givenIndex()
        // When
        var item = [1.0, 1.0, 1.0]
        
        // Then
        XCTAssertThrowsError(try sut.addItem(index: 0,vector: &item)) { error in
            guard case AnnoyIndexError.invalidVectorLength(_) = error else {
                return XCTFail()
            }
        }
    }
    
    func test_addItems_whenNoItemsInIndex_enumeratesIndicesStartingWithZero() {
        // Given
        givenIndex()
        var data = testData()
        
        // When
        try! sut.addItems(items: &data)
        
        // Then
        let item0 = data[0]
        let indexItem0 = sut.getItem(index: 0)!
        assertVecsEqual(vec1: indexItem0, vec2: item0)
        let item3 = data[3]
        let indexItem3 = sut.getItem(index: 3)!
        assertVecsEqual(vec1: indexItem3, vec2: item3)
    }
    
    func test_addItems_givenItemsInIndex_continuesIndexingFromCurrentItemCount() {
        // Given
        givenIndex()
        var data = testData()
        try! sut.addItems(items: &data)
        
        // When
        var newData = [[4.0, 4.0],[5.0, 5.0]]
        try! sut.addItems(items: &newData)
        
        // Then
        let indexItem = sut.getItem(index: data.count)!
        let expecteditem = newData[0]
        assertVecsEqual(vec1: indexItem, vec2: expecteditem)
    }
    
    func test_getDistance_euclidean_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .euclidean)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, 0.0)
    }
    
    func test_getDistance_manhattan_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .manhattan)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, 0.0)
    }
    
    func test_getDistance_angular_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .angular)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, 0.0)
    }
    
    func test_getDistance_dotProduct_whenSameItem_returnsDotOfSelf() {
        // Given
        givenIndex(metric: .dotProduct)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        let expectedDistance = 1.0
        XCTAssertEqual(distance!, expectedDistance)
    }
    
    func test_getDistance_euclidean_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .euclidean)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 3, item2: 4)
        
        let expectedDistance = 5.0
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: 0.000001)
    }
    
    func test_getDistance_manhattan_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .manhattan)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 1)
        
        let expectedDistance =  2.0
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: 0.000001)
    }
    
    func test_getDistance_angular_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .angular)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 2)
        
        let expectedDistance =  2.0
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: 0.000001)
    }
    
    func test_getDistance_dotProduct_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .dotProduct)
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 3, item2: 4)
        
        let expectedDistance =  9.0
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: 0.000001)
    }
    
    func test_getDistance_whenItemIndexOutBounds_returnsNil() {
        // Given
        givenIndex()
        givenTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 100)
        
        // Then
        XCTAssertNil(distance)
    }
    
    func test_getNNsForItem_angular_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .angular)
        givenTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 2)!
        
        // Then
        let expectedIndices = [0, 3]

        let expectedDistances  = [0, sqrt(2*(1-sqrt(2)/2))]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    func test_getNNsForItem_dotProduct_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .dotProduct)
        givenTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 0]
        let expectedDistances  = [7.0, 4.0, 1.0]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    
    
    func test_getNNsForItem_euclidean_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .euclidean)
        givenTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 5, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances  = [0.0, 5.0, 10.0]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    func test_getNNsForItem_manhattan_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .manhattan)
        givenTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 3)!
        
        // Then
        let expectedIndices = [0, 3, 1]
        let expectedDistances  = [0.0, 1.0, 2.0]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }

    func test_getNNsForVector_angular_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .angular)
        givenTestData()
        try! sut.build(numTrees: 1)
        var vector = [1.0, 0.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 2)!
        
        // Then
        let expectedIndices = [0, 3]
        let expectedDistances = [0.0, sqrt(2*(1-sqrt(2)/2))]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_dotProduct_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .dotProduct)
        givenTestData()
        try! sut.build(numTrees: 1)
        var vector = [1.0, 1.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances = [16.0, 9.0, 2.0]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_euclidean_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .euclidean)
        givenTestData()
        try! sut.build(numTrees: 1)
        var vector = [7.0, 9.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances = [0.0, 5.0, 10.0]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_manhattan_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .manhattan)
        givenTestData()
        try! sut.build(numTrees: 1)
        var vector = [7.0, 9.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances = [0.0, 7.0, 14.0]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
}

