import XCTest
@testable import SwiftAnnoy

final class AnnoyIndexTests: XCTestCase {
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
       // XCTAssertEqual(SwiftAnnoy().text, "Hello, World!")
        let sut = AnnoyIndex<Float>(numFeatures: 2)
        var item1: [Float] = [1.0, 2.0]
        sut.addItem(index: 0, vector: &item1)
        sut.build(numTrees: 1)
        print(sut.numberOfItems)
        
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
