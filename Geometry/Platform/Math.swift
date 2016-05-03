//
//  Math.swift
//  Pods
//
//  Created by Tony Stone on 5/2/16.
//
//

import Swift

#if os(Linux)
    import Glibc
#else
    import Darwin
#endif

public final class Math {
    
    public class func max<T : Comparable>(_ x: T, _ y: T) -> T {
        if y > x { return y }
        return x
    }
}

