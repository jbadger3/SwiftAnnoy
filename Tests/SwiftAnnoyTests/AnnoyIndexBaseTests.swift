//
//  File 2.swift
//  
//
//  Created by Jonathan Badger on 5/27/20.
//

import XCTest
@testable import SwiftAnnoy

final class AnnoyIndexBaseTests: XCTestCase {
    typealias DistanceMetric = AnnoyIndex<Double>.DistanceMetric

    var sut:AnnoyIndex<Double>!
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    //MARK: Given
    func givenIndex(itemLength: Int = 2, metric: DistanceMetric = DistanceMetric.euclidean) {
        sut = AnnoyIndex<Double>(itemLength: itemLength, metric: metric)
    }
    //MARK: - Given
    func givenTestData() {
        var data = testData()
        for (index, _) in data.enumerated() {
            try! sut.addItem(index: index, vector: &data[index])
        }
    }
    
    func test_init_setsNumFeatures() {
        // Given
        let itemLength = 5
        
        // When
        givenIndex(itemLength: itemLength)
        
        // Then
        XCTAssertEqual(sut.itemLength, itemLength)
    }
    
    //TODO: Add build tests
    
    //TODO: Add unbuild tests
    
    func test_save_whenFails_throwsSaveFailedError() {
        // Given
        givenIndex()
        let url = URL(string: "/test/url/path")!
        
        // When/Then
        XCTAssertThrowsError(try sut.save(url: url)) { error in
            guard case AnnoyIndexError.saveFailed = error else {
                return XCTFail()
            }
        }
    }
    
    func test_save_whenSuccess_newFileCreated() {
        // Given
        givenIndex()
        let fileManager = FileManager.default
        var url = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        url.appendPathComponent("test.index")
        givenTestData()
        try! sut.build(numTrees: 1)
        
        // When
        try! sut.save(url: url)
        
        // Then
        let success = fileManager.fileExists(atPath: url.path)
        XCTAssertTrue(success)
    }
    
    //TODO: Add build tests
    
    //TODO: Add unbuild tests
    
    //TODO: Add unload tests
    
    func test_load_whenSuccessful_itemsLoaded() {
        // Given
        givenIndex()
        let fileManager = FileManager.default
        var url = try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        url.appendPathComponent("test.index")
        givenTestData()
        
        try! sut.build(numTrees: 1)
        try! sut.save(url: url)
        givenIndex()
        XCTAssertEqual(sut.numberOfItems, 0) //verify new index with no loaded items
        
        // When
        try! sut.load(url: url)
        
        // Then
        XCTAssertEqual(sut.numberOfItems, testData().count)
    }
    
    func test_load_whenFails_throwsLoadFailedError() {
        //Given
        givenIndex()
        let url = URL(string: "/test/url/fake.file")!
        
        XCTAssertThrowsError(try sut.load(url: url)) { error in
            guard case AnnoyIndexError.loadFailed = error else {
                return XCTFail()
            }
        }
    }
    
    //TODO: setVerbose
    
    //TODO: getItem
    
    //TODO: setSeed
    
    //TODO: onDiskBuild
}
