//
//  AnnoyIndex.swift
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 5/4/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//

import Foundation
import CAnnoyWrapper

public class AnnoyIndex<T: Numeric> {
    public enum DistanceMetric: String{
        case euclidean
        case manhattan
        case hamming
        case dotProduct
    }
    
    //MARK: - Properties
    private let indexPointer: UnsafeRawPointer
    public private(set) var numFeatures: Int
    public private(set) var distanceMetric: [CChar]
    public private(set) var dataType: [CChar]
    
    /**
    The number of items in the index.
    */
    public var numberOfItems: Int32 {
        get {
            return C_get_n_items(indexPointer)
        }
    }
    
    /**
        The number of trees in the index. (if built)
     */
    public var numberOfTrees: Int32 {
        get {
            return C_get_n_trees(indexPointer)
        }
    }
    
    /**
        - Parameters:
            - numFeatures: The number of features in each item.
            - metric: The metric to be used to measure the distance between items.  One of .euclidean, .manhattan, .hamming, or .dotProduct
     */
    
    public init(numFeatures features: Int, metric: DistanceMetric = .euclidean) {
        numFeatures = features
        distanceMetric = metric.rawValue.cString(using: .utf8)!
        dataType = String(describing: T.self).cString(using: .utf8)!
        indexPointer = C_initializeAnnoyIndex(Int32(numFeatures), &distanceMetric, &dataType)!
    }
    
    /**
     Adds an a new item to the index.
     
     - Parameters:
        - index: The index (integer) to assign to the item.
        - vector: Array representing the feature vector for the item.
     
     */
    
    public func addItem(index: Int, vector: inout [T]) -> Bool {
        let i = Int32(index)
        let result = vector.withUnsafeMutableBufferPointer { (buffer) -> Bool in
            let p = buffer.baseAddress
            return C_add_item(i, p, &distanceMetric, &dataType, indexPointer)
        }
        return result
    }
    
    public func build(numTrees: Int) -> Bool {
        return C_build(Int32(numTrees), &distanceMetric, &dataType, indexPointer)
    }
    public func unbuild() -> Bool{
        return C_unbuild(indexPointer)
    }
    public func save(url: URL) {
        guard var filenameCString = url.path.cString(using: .utf8) else {
            return
        }
        let success = C_save(&filenameCString, indexPointer)
    }
    
    public func unload() {
        C_unload(indexPointer)
    }
        
    public func getDistance(item1: Int, item2: Int) -> Any? {
        if T.self is Float.Type {
            var result = Float(-1.0)
            C_get_distance(Int32(item1), Int32(item2),&result, &distanceMetric, &dataType, indexPointer)
            return result
        }
        if T.self is Int32.Type {
            var result = Int32(1)
            C_get_distance(Int32(item1), Int32(item2),&result, &distanceMetric, &dataType, indexPointer)
            return Float(result)
        }
        return nil
    }
    
    public func getNNSFor(item: Int, neighbors: Int, search_k: Int = -1, distance: Bool = true) -> (indices: [Int32], distances: [Any]?) {
        var results: [Int32] = Array(repeating: -1, count: neighbors)
        
        if T.self is Float.Type {
            var distances = Array(repeating: Float(-1.0), count: neighbors)
            C_get_nns_by_item(Int32(item), Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results, distances)
        }
        if T.self is Int32.Type {
            var distances = Array(repeating: Int32(-1.0), count: neighbors)
            C_get_nns_by_item(Int32(item), Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results, distances)
        }
        
        return (results, nil)
    }
    
    public func getNNSFor(vector: inout [T], neighbors: Int, search_k: Int = -1, distance: Bool = true) -> (indices: [Int32], distances: [Any]?) {
        var results: [Int32] = Array(repeating: -1, count: neighbors)
        
        if T.self is Float.Type {
            var distances = Array(repeating: Float(-1.0), count: neighbors)
            C_get_nns_by_vector(&vector, Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results, distances)
        }
        if T.self is Int32.Type {
            var distances = Array(repeating: Int32(-1.0), count: neighbors)
            C_get_nns_by_vector(&vector, Int32(neighbors), Int32(search_k), &results, &distances, &distanceMetric, &dataType, indexPointer)
            return (results, distances)
        }
        
        return (results, nil)
        //return (results, distances)
    }
    
    public func setVerbos(boolVal: Bool) {
        C_verbose(boolVal, indexPointer)
    }
    
    public func getItem(index: Int) -> [Any]? {
        if T.self is Float.Type {
            var item: [Float32] = Array(repeating: -1.0, count: numFeatures)
            C_get_item(Int32(index), &item, &distanceMetric, &dataType, indexPointer)
            return item
        }
        if T.self is Int32.Type {
            var item: [Int32] = Array(repeating: -1, count: numFeatures)
            C_get_item(Int32(index), &item, &distanceMetric, &dataType, indexPointer)
            return item
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
