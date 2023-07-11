//
//  AnnoyIndex.swift
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 5/4/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//

import Foundation
import CAnnoyWrapper

/// The primary generic class used to create an index.
public class AnnoyIndex<T: AnnoyOperable> {
    
    /// Supported distance metrics / similarity measures
    public enum DistanceMetric: String{
        /// The angular distance used is the Euclidean distance of normalized vectors, which is sqrt(2(1-cos(u,v)))
        case angular
        /// The dot product also called the inner product.
        case dotProduct
        /// The L2  or straight line distance as calculated using the Pythagorean formula
        case euclidean
        /// The L1 or city block distance
        case manhattan
    }

    //MARK: - Properties
    private let indexPointer: UnsafeRawPointer
    /// The length of each vector (Array count if you wish) for each item in the index.
    public private(set) var itemLength: Int
    /// The distance metric used to measure the similarity between vectors.
    public private(set) var distanceMetric: [CChar]
    /// The type of data being used in each vector.
    public private(set) var dataType: [CChar]
    
    /**
    The number of items in the index.
    */
    public var numberOfItems: Int {
        get {
            return Int(C_get_n_items(indexPointer))
        }
    }
    
    /**
        The number of trees in the index. (if built)
     */
    public var numberOfTrees: Int {
        get {
            return Int(C_get_n_trees(indexPointer))
        }
    }
    
    /**
        - Parameters:
            - itemLength: The vector length (Array.count) of each item stored in the index .
            - metric: The metric to be used to measure the distance between items.  One of .angular, .dotProduct, .euclidean, or .manhattan
     */
    public init(itemLength: Int, metric: DistanceMetric = .euclidean) {
        self.itemLength = itemLength
        distanceMetric = metric.rawValue.cString(using: .utf8)!
        dataType = String(describing: T.self).cString(using: .utf8)!
        indexPointer = C_initializeAnnoyIndex(Int32(itemLength), &distanceMetric, &dataType)!
    }
    
    
    deinit {
        C_unload(indexPointer)
        C_deleteAnnoyIndex(indexPointer)
    }
    
    /**
     Adds an a new item to the index.
     
     - Parameters:
        - index: The index (integer) to assign to the item.
        - vector: Array representing the feature vector for the item.
     - Throws: `AnnoyIndexError.addItemFailed`
     */
    public func addItem(index: Int, vector: inout [T]) throws {
        guard self.itemLength == vector.count else {
            throw AnnoyIndexError.invalidVectorLength(message: "Expected vector.count = \(self.itemLength), input vector.count was \(vector.count).")
        }
        let i = Int32(index)
        let success = vector.withUnsafeMutableBufferPointer { (buffer) -> Bool in
            let p = buffer.baseAddress
            return C_add_item(i, p, &distanceMetric, &dataType, indexPointer)
        }
        if !success {
            throw AnnoyIndexError.addItemFailed
        }
    }
    
    /**
    Adds multiple new items to the index.
     
     - Parameters:
        - items: An Array of vectors to add to the index.
     - Throws: AnnoyIndexError.addIemFailed
     */
    public func addItems(items: inout [[T]]) throws {
        let beginningNumItems = self.numberOfItems
        for (index, _) in items.enumerated() {
            try self.addItem(index: index + beginningNumItems, vector: &items[index])
        }
    }
    
    /**
    Builds the index to allow for fast approximate nearest neighbors lookup.
     
     Using a larger number of  trees to build the index will take longer, but will also lead to better accuracy
     during querying.  You may need to experiment to find the right balance.
     - Parameters:
        - numTrees: The number of trees to use to build the index.
     */
    public func build(numTrees: Int) throws {
        let success = C_build(Int32(numTrees), &distanceMetric, &dataType, indexPointer)
        if !success {
            throw AnnoyIndexError.buildFailed
        }
    }
    
    /**
    Unbuilds the current AnnoyIndex which allows additional items to be added or for the index to be rebuilt with a
     different number of trees.
     - Throws:  AnnoyIndexError.UnbuildFailed
     */
    public func unbuild() throws {
        let success = C_unbuild(indexPointer)
        if !success {
            throw AnnoyIndexError.unbuildFailed
        }
    }
    
    /**
     Saves the current index to a file then immediately loads (memory maps) the index from disk.
     
     - Parameters:
        - url: The file destination URL for the index.
        - prefault: If set to true the entire file will be preread into memory.
     - Throws: AnnoyIndexError.saveFailed
     */
    public func save(url: URL, prefault: Bool = false) throws {
        guard var filenameCString = url.path.cString(using: .utf8) else {
            return
        }
        let success = C_save(&filenameCString, prefault, indexPointer)
        if !success {
            throw AnnoyIndexError.saveFailed
        }
    }
    
    /**
     Unloads the underlying index and all associated items.
     */
    public func unload() {
        C_unload(indexPointer)
    }
    
    /**
     Loads a previously saved index.
     - Parameters:
        - url: The file URL to load
        - prefault: If set to true the entire file will be preread into memory.  Default is false which uses memory mapping.
     - Throws: AnnoyIndexError.loadFailed
     */
    public func load(url: URL, prefault: Bool = false) throws {
        guard let filenameCString = url.path.cString(using: .utf8) else {
            return
        }
        let success = C_load(filenameCString, &distanceMetric, &dataType, prefault, indexPointer)
        if !success {
            throw AnnoyIndexError.loadFailed
        }
        
    }
    
    /**
     Calculates the distance between two items in the index.
     - Parameters:
        - item1: The index of first item of inerest.
        - item2: The index of the second item of interest.
     - Returns: The distance between the two items or nil if one of the items is not in the index.
     */
    public func getDistance(item1: Int, item2: Int) -> T? {
        if (item1 >= self.numberOfItems) || (item2 >= self.numberOfItems) { return nil }
        switch T.self {
        case is Float.Type:
            var result = Float(-1.0)
            C_get_distance(Int32(item1), Int32(item2),&result, &distanceMetric, &dataType, indexPointer)
            return result as? T
        case is Double.Type:
            var result = Double(-1.0)
            C_get_distance(Int32(item1), Int32(item2),&result, &distanceMetric, &dataType, indexPointer)
            return result as? T
        default:
            return nil
        }
    }
    
    /**
     Gathers the approximate nearest neighbors for an item.
     
    - Parameters:
        - item: The index of the item of interest.
        - neighbors: The number of neighbors to return.
        - search_k:  The number of nodes to inspect during search. search_k defaults to n * n_trees * D where n is the number of approximate nearest neighbors and D is a constant determined by Annoy based on the distance metric.  In general, increasing search_k increases search time, but will give more accurate results.
     - Returns: A tuple of arrays containing the item indicies and distances.
     */
    public func getNNsForItem(item: Int, neighbors: Int, search_k: Int = -1) -> (indices: [Int], distances: [T])? {
        var indices: [Int32] = Array(repeating: -1, count: neighbors)
        switch T.self {
        case is Float.Type:
            var distances = Array(repeating: Float(-1.0), count: neighbors)
            C_get_nns_by_item(Int32(item), Int32(neighbors), Int32(search_k), &indices, &distances, &distanceMetric, &dataType, indexPointer)
            return (indices.toInt(), distances as! [T])
        case is Double.Type:
            var distances = Array(repeating: Double(-1.0), count: neighbors)
            C_get_nns_by_item(Int32(item), Int32(neighbors), Int32(search_k), &indices, &distances, &distanceMetric, &dataType, indexPointer)
            return (indices.toInt(), distances as! [T])
        default:
            return nil
        }
    }
    
    /**
     Gathers the approximate nearest neighbors for a vector.
     
    - Parameters:
        - vector: The vector of interest.
        - neighbors: The number of neighbors to return.
        - search_k:  The number of nodes to inspect during search. search_k defaults to n * n_trees * D where n is the number of approximate nearest neighbors and D is a constant determined by Annoy based on the distance metric.  In general, increasing search_k increases search time, but will give more accurate results.
     - Returns: A tuple of arrays containing the item indicies and distances.
     */
    public func getNNsForVector(vector: inout [T], neighbors: Int, search_k: Int = -1) -> (indices: [Int], distances: [T])? {
        var results: [Int32] = Array(repeating: -1, count: neighbors)
        switch T.self {
        case is Float.Type:
            var distances = Array(repeating: Float(-1.0), count: neighbors)
            C_get_nns_by_vector(&vector, Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results.toInt(), distances as! [T])
        case is Double.Type:
            var distances = Array(repeating: Double(-1.0), count: neighbors)
            C_get_nns_by_vector(&vector, Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results.toInt(), distances as! [T])
        default:
            return nil
        }
    }
    
    /**
     When set to true provides additional information about operations carried out by Annoy via stdout.
     */
    public func setVerbos(boolVal: Bool) {
        C_verbose(boolVal, indexPointer)
    }
    
    /**
     Retrieves the vector for an item in the index.
    - Parameters:
        - item: The index of the item to retrieve
     - Returns: The vector associated with the item or nil if not found.
     */
    public func getItem(index: Int) -> [T]? {
        if T.self is Float.Type {
            var item: [Float] = Array(repeating: -1.0, count: itemLength)
            C_get_item(Int32(index), &item, &distanceMetric, &dataType, indexPointer)
            return item as? [T]
        }
        if T.self is Double.Type {
            var item: [Double] = Array(repeating: -1, count: itemLength)
            C_get_item(Int32(index), &item, &distanceMetric, &dataType, indexPointer)
            return item as? [T]
        }
        return nil
    }
    
    /**
     Sets the random seed used for generating the index.  Setting this value is useful when running performance testing to ensure consistent results.
     */
    public func setSeed(seedVal: Int) {
        C_set_seed(Int32(seedVal), indexPointer)
    }
    
    /**
     Prepares the index to be built on disk rather than in RAM.  Should be set before adding items to the index.
    - Parameters:
        - url: A file destination URL for the index.
     */
    public func onDiskBuild(url: URL) {
        guard var filenameCString = url.path.cString(using: .utf8) else { return }
        C_on_disk_build(&filenameCString, indexPointer)
    }
    
}

extension Array where Element: BinaryInteger {
    func toInt() -> [Int] {
        return self.map({Int($0)})
    }
}
