//
//  Hash.swift
//  Pods
//
//  Created by Tony Stone on 2/28/16.
//
//

import Swift

/**
    Combine mutlipile hashes producing a new hash representing the combined hash values.
*/
@warn_unused_result
internal  func combineHashes(h1: Int, _ h2: Int) -> Int {
    // Shift-Add-XOR hash algorithm
    var hash = h1
    
    hash ^= (hash << 5) &+ (hash >> 2) &+ h2
    
    return hash
}

/**
    Combine mutlipile hashes producing a new hash representing the combined hash values.
*/
@warn_unused_result
internal  func combineHashes(h1: Int, _ h2: Int, _ h3: Int, _ rest: Int...) -> Int {
    // Shift-Add-XOR hash algorithm
    var hash = h1
    
    hash ^= (hash << 5) &+ (hash >> 2) &+ h2
    hash ^= (hash << 5) &+ (hash >> 2) &+ h3
    
    for hashValue in rest {
        hash ^= (hash << 5) &+ (hash >> 2) &+ hashValue
    }
    return hash
}