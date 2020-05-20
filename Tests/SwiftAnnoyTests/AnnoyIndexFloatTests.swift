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
        let item3: [Float] = [3.0, 3.0, 4.0]
        let item4: [Float] = [1.1, 2.1, 3.1]
        let testData = [item0, item1, item2, item3, item4]
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
    
    func test_addItems_whenNoItemsInIndex_enumeratesIndicesStartingWithZero() {
        // Given
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
        var testData = floatTestData()
        try! sut.addItems(items: &testData)
        
        // When
        var newData: [[Float]] = [[4.0, 4.0, 4.0],[5.0, 5.0, 5.0]]
        try! sut.addItems(items: &newData)
        
        // Then
        let indexItem5 = sut.getItem(index: 5)!
        let expecteditem5 = newData[0]
        assertVecsEqual(vec1: indexItem5, vec2: expecteditem5)
    }
    
    //TODO: Add build tests
    
    //TODO: Add unbuild tests
    
    func test_save_whenFails_throwsSaveFailedError() {
        let url = URL(string: "/test/url/path")!
        XCTAssertThrowsError(try sut.save(url: url)) { error in
            guard case AnnoyIndexError.saveFailed = error else {
                return XCTFail()
            }
        }
    }
    
    func test_save_whenSuccess_newFileCreated() {
        // Given
        let fileManager = FileManager.default
        var url = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        url.appendPathComponent("test.index")
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        try! sut.save(url: url)
        
        // Then
        let success = fileManager.fileExists(atPath: url.path)
        XCTAssertTrue(success)
    }
    
    //TODO: Add unload tests
    
    func test_load_whenSuccessful_itemsLoaded() {
        // Given
        let fileManager = FileManager.default
        var url = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        url.appendPathComponent("test.index")
        var testData = floatTestData()
        try! sut.addItems(items: &testData)
        try! sut.build(numTrees: 1)
        try! sut.save(url: url)
        sut = givenFloatIndex()
        XCTAssertEqual(sut.numberOfItems, 0) //verify new index with no loaded items
        
        // When
        try! sut.load(url: url)
        
        // Then
        XCTAssertEqual(sut.numberOfItems, testData.count)
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
    
    func test_getDistance_whenItemIndexOutBounds_returnsNil() {
        // Given
        givenFloatTestData()
        
        // When
        let distance = sut.getDistance(item1: 0, item2: 100)
        
        // Then
        XCTAssertNil(distance)
    }
    
    func test_getNNsForItem_whenValidIndex_returnsCorrectItemsAndDistances() {
        // Given
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        
        // When
        let results = sut.getNNsForItem(item: 2, neighbors: 4)!
        
        // Then
        let expectedIndices = [2, 4, 0, 3]
        let expectedDistances : [Float] = [0, 0.173204988, 2.2360681, 2.4494893]
        assertVecsEqual(vec1: results.indices, vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances , vec2: expectedDistances)
    }
    
    func test_getNNsForVector_returnsCorrectItemsAndDistances() {
        // Given
        givenFloatTestData()
        try! sut.build(numTrees: 1)
        var vector: [Float] = [1.0, 2.0, 3.0]
        
        // When
        let results = sut.getNNsForVector(vector: &vector, neighbors: 3)!
        
        // Then
        let expectedIndices = [2, 4, 0]
        let expectedDistances: [Float] = [0.0, 0.1732049, 2.2360681]
        assertVecsEqual(vec1: results.indices , vec2: expectedIndices)
        assertVecsEqual(vec1: results.distances, vec2: expectedDistances)
    }
    
    func test_temp() {
        var newsut = AnnoyIndex<Float>(itemLength: 2, metric: .manhattan)
        var vec1: [Float] = [1,2]
        var vec2: [Float] = [2,5]
        try! newsut.addItem(index: 0, vector: &vec1)
        try! newsut.addItem(index: 1, vector: &vec2)
        try! newsut.build(numTrees: 1)
        
        let distance = newsut.getDistance(item1: 0, item2: 1)
        print("hi")
    }
    


    
    
  


}
