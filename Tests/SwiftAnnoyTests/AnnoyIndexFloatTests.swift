import XCTest
@testable import SwiftAnnoy

final class AnnoyIndexFloatTests: XCTestCase {
    typealias DistanceMetric = AnnoyIndex<Float>.DistanceMetric
    
    var sut:AnnoyIndex<Float>!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Given
    func givenFloatTestData() {
        var testData = floatTestData()
        for (index, _) in testData.enumerated() {
            try! sut.addItem(index: index, vector: &testData[index])
        }
    }
    
    func givenIndex(itemLength: Int = 2, metric: DistanceMetric = DistanceMetric.euclidean) {
        sut = AnnoyIndex<Float>(itemLength: itemLength, metric: metric)
    }

    func test_addItem_updatesNumItems() {
        // Given
        givenIndex()
        var item: [Float] = [1.0, 1.0]
        
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
        var item: [Float] = [1.0, 1.0]
        try! sut.addItem(index: 0, vector: &item)
        let itemBack = sut.getItem(index: 0)
        assertVecsEqual(vec1: item, vec2: itemBack!)
        
        // When
        var item2: [Float] = [2.0, 1.0]
        try! sut.addItem(index: 0, vector: &item2)
        
        // Then
        let itemBack2 = sut.getItem(index: 0)
        assertVecsEqual(vec1: item2, vec2: itemBack2!)
    }
    
    func test_addItem_whenWrongVectorLength_throwsInvalidVectorSizeError() {
        // Given
        givenIndex()
        // When
        var item: [Float] = [1.0, 1.0, 1.0]
        
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
        var testData = floatTestData()
        
        // When
        try! sut.addItems(items: &testData)
        
        // Then
        let item0 = testData[0]
        let indexItem0 = sut.getItem(index: 0)!
        assertVecsEqual(vec1: indexItem0, vec2: item0)
        let item3 = testData[3]
        let indexItem3 = sut.getItem(index: 3)!
        assertVecsEqual(vec1: indexItem3, vec2: item3)
    }
    
    func test_addItems_givenItemsInIndex_continuesIndexingFromCurrentItemCount() {
        // Given
        givenIndex()
        var testData = floatTestData()
        try! sut.addItems(items: &testData)
        
        // When
        var newData: [[Float]] = [[4.0, 4.0],[5.0, 5.0]]
        try! sut.addItems(items: &newData)
        
        // Then
        let indexItem = sut.getItem(index: testData.count)!
        let expecteditem = newData[0]
        assertVecsEqual(vec1: indexItem, vec2: expecteditem)
    }
    
    func test_getDistance_euclidean_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .euclidean)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, Float(0))
    }
    
    func test_getDistance_manhattan_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .manhattan)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, Float(0))
    }
    
    func test_getDistance_angular_whenSameItem_returnsDistanceZero() {
        // Given
        givenIndex(metric: .angular)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, Float(0))
    }
    
    func test_getDistance_dotProduct_whenSameItem_returnsDotOfSelf() {
        // Given
        givenIndex(metric: .dotProduct)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        let expectedDistance = Float(1.0)
        XCTAssertEqual(distance!, expectedDistance)
    }
    
    func test_getDistance_euclidean_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .euclidean)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 3, item2: 4)
        
        let expectedDistance = Float(5.0)
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: Float(0.000001))
    }
    
    func test_getDistance_manhattan_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .manhattan)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 1)
        
        let expectedDistance =  Float(2.0)
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: Float(0.000001))
    }
    
    func test_getDistance_angular_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .angular)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 2)
        
        let expectedDistance =  Float(2.0)
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: Float(0.000001))
    }
    
    func test_getDistance_dotProduct_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenIndex(metric: .dotProduct)
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 3, item2: 4)
        
        let expectedDistance =  Float(9.0)
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: Float(0.000001))
    }
    
    func test_getDistance_whenItemIndexOutBounds_returnsNil() {
        // Given
        givenIndex()
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 100)
        
        // Then
        XCTAssertNil(distance)
    }
    
    func test_getNNsForItem_angular_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .angular)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 2)!
        
        // Then
        let expectedIndices = [0, 3]

        let expectedDistances : [Float] = [0, sqrt(2*(1-Float(sqrt(2)/2)))]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    func test_getNNsForItem_dotProduct_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .dotProduct)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 0]
        let expectedDistances : [Float] = [7, 4, 1]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    
    
    func test_getNNsForItem_euclidean_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .euclidean)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 5, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances : [Float] = [0, 5, 10]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    func test_getNNsForItem_manhattan_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .manhattan)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 0, neighbors: 3)!
        
        // Then
        let expectedIndices = [0, 3, 1]
        let expectedDistances : [Float] = [0, 1, 2]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }

    func test_getNNsForVector_angular_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .angular)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        var vector: [Float] = [1.0, 0.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 2)!
        
        // Then
        let expectedIndices = [0, 3]
        let expectedDistances: [Float] = [0.0, sqrt(2*(1-Float(sqrt(2)/2)))]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_dotProduct_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .dotProduct)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        var vector: [Float] = [1.0, 1.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances: [Float] = [16, 9, 2]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_euclidean_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .euclidean)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        var vector: [Float] = [7.0, 9.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances: [Float] = [0, 5, 10]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_getNNsForVector_manhattan_returnsCorrectItemsAndDistances() {
        // Given
        givenIndex(metric: .manhattan)
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        var vector: [Float] = [7.0, 9.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [5, 4, 3]
        let expectedDistances: [Float] = [0, 7, 14]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
}
