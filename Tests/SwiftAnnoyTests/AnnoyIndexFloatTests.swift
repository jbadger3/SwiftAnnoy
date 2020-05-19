import XCTest
@testable import SwiftAnnoy

final class AnnoyIndexFloatTests: XCTestCase {
    typealias DistanceMetric = AnnoyIndex<Float>.DistanceMetric
    
    var sut:AnnoyIndex<Float>!
    
    override func setUp() {
        super.setUp()
        sut = givenFloatIndex()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: - Given
    func floatTestData() -> [[Float]] {
        let item0: [Float] = [1.0, 1.0, 1.0]
        let item1: [Float] = [-1.0, 0.0, 1.0]
        let item2: [Float] = [1.0, 2.0, 3.0]
        let item3: [Float] = [4.0, 4.0, 4.0]
        let testData = [item0, item1, item2, item3]
        return testData
    }
    
    func givenFloatTestData() {
        var testData = floatTestData()
        for (index, _) in testData.enumerated() {
            try! sut.addItem(index: index, vector: &testData[index])
        }
    }
    
    func givenFloatIndex(itemLength: Int = 3, metric: DistanceMetric = DistanceMetric.euclidean) -> AnnoyIndex<Float> {
        return AnnoyIndex<Float>(itemLength: itemLength, metric: metric)
    }

    func test_init_setsNumFeatures() {
        let itemLength = 5
        let sut = givenFloatIndex(itemLength: itemLength)
        XCTAssertEqual(sut.itemLength, itemLength)
    }
    
    func test_addItem_updatesNumItems() {
        var item: [Float] = [1.0, 1.0, 1.0]
        try! sut.addItem(index: 0, vector: &item)
        XCTAssertEqual(sut.numberOfItems, 1)
        try! sut.addItem(index: 1, vector: &item)
        XCTAssertEqual(sut.numberOfItems, 2)
    }
    
    func test_addItem_whenOverwritingOldIndex_UpdatesStoredItem() {
        var item: [Float] = [1.0, 1.0, 1.0]
        try! sut.addItem(index: 0, vector: &item)
        let itemBack = sut.getItem(index: 0)
        assertVecsEqual(vec1: item, vec2: itemBack!)
        var item2: [Float] = [2.0, 1.0, 1.0]
        try! sut.addItem(index: 0, vector: &item2)
        let itemBack2 = sut.getItem(index: 0)
        assertVecsEqual(vec1: item2, vec2: itemBack2!)
    }
    
    func test_addItem_whenWrongVectorLength_throwsInvalidVectorSizeError() {
        // When
        var item: [Float] = [1.0, 1.0, 1.0, 2.0]
        
        // Then
        XCTAssertThrowsError(try sut.addItem(index: 0,vector: &item)) { error in
            guard case AnnoyIndexError.invalidVectorLength(_) = error else {
                return XCTFail()
            }
        }
    }
    
    func test_addItems_whenNoIndicesGiven_setsIndicesToByEnumeratingItems() {
        // Given
        var testData = floatTestData()
        
        // When
        try! sut.addItems(indices: nil, items: &testData)
        
        // Then
        let item0 = testData[0]
        let indexItem0 = sut.getItem(index: 0)!
        assertVecsEqual(vec1: indexItem0, vec2: item0)
        let item3 = testData[3]
        let indexItem3 = sut.getItem(index: 3)!
        assertVecsEqual(vec1: indexItem3, vec2: item3)
    }
    
    func test_addItems_whenIndicesGiven_setsIndicesAndItemsCorrectly() {
        // Given
        var testData = floatTestData()
        let indices = [3, 2, 1, 0]
        // When
        try! sut.addItems(indices: indices, items: &testData)
        
        let indexItem3 = sut.getItem(index: 3)!
        let item0 = testData[0]
        assertVecsEqual(vec1: indexItem3, vec2: item0)
    }
    
    func test_addItems_whenIndiceCountAndItemCountDiffer_throwsError() {
        //Given
        var testData = floatTestData()
        let indices = [4, 3, 2, 1, 0]
        XCTAssertThrowsError(try sut.addItems(indices: indices, items: &testData))
    }
    
    //Add build tests
    //Add unbuild tests
    
    func test_save_whenFails_throwsSaveFailedError() {
        let url = URL(string: "/test/url/path")!
        XCTAssertThrowsError(try sut.save(url: url)) { error in
            guard case AnnoyIndexError.saveFailed = error else {
                return XCTFail()
            }
        }
    }
     
    func test_getDistance_whenSameItem_returnsDistanceZero() {
        // Given
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 0)
        
        // Then
        XCTAssertEqual(distance!, Float(0))
    }
    
    func test_getDistance_whenItemDifferent_returnsCorrectDistance() {
        // Given
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 1)
        
        let expectedDistance = Float(sqrt(5.0)) // item0, item1 euclidean distance
        // Then
        XCTAssertEqual(distance!, expectedDistance, accuracy: Float(0.000001))
    }

    
    
  


}
