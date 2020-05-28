//
//  AnnoyIndex.swift
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 5/4/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//

import Foundation
import CAnnoyWrapper

public class AnnoyIndex<T: AnnoyOperable> {
    
    public enum DistanceMetric: String{
        case angular
        case dotProduct
        case euclidean
        case manhattan
    }

    //MARK: - Properties
    private let indexPointer: UnsafeRawPointer
    public private(set) var itemLength: Int
    public private(set) var distanceMetric: [CChar]
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
            - numFeatures: The number of features in each item.
            - metric: The metric to be used to measure the distance between items.  One of .euclidean, .manhattan, .hamming, or .dotProduct
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
    
    public func addItems(items: inout [[T]]) throws {
        let beginningNumItems = self.numberOfItems
        for (index, _) in items.enumerated() {
            try? self.addItem(index: index + beginningNumItems, vector: &items[index])
        }
    }
    
    public func build(numTrees: Int) throws {
        let success = C_build(Int32(numTrees), &distanceMetric, &dataType, indexPointer)
        if !success {
            throw AnnoyIndexError.buildFailed
        }
    }
    
    public func unbuild() throws {
        let success = C_unbuild(indexPointer)
        if !success {
            throw AnnoyIndexError.unbuildFailed
        }
    }
    
    public func save(url: URL, prefault: Bool = false) throws {
        guard var filenameCString = url.path.cString(using: .utf8) else {
            return
        }
        let success = C_save(&filenameCString, prefault, indexPointer)
        if !success {
            throw AnnoyIndexError.saveFailed
        }
    }
    
    public func unload() {
        C_unload(indexPointer)
    }
    
    public func load(url: URL) throws {
        guard let filenameCString = url.path.cString(using: .utf8) else {
            return
        }
        let success = C_load(filenameCString, &distanceMetric, &dataType, indexPointer)
        if !success {
            throw AnnoyIndexError.loadFailed
        }
        
    }
        
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
    
    public func setVerbos(boolVal: Bool) {
        C_verbose(boolVal, indexPointer)
    }
    
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
    
    public func setSeed(seedVal: Int) {
        C_set_seed(Int32(seedVal), indexPointer)
    }
    
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
