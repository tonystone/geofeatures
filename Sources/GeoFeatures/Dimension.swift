/*
 *   Dimension.swift
 *
 *   Copyright 2016 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 *
 *   Created by Tony Stone on 4/24/16.
 */
import Swift

/**
    Dimension represents the spatial dimension of a Geometry type. 
 
    The dimension of empty sets are donated as EMPTY (-1).  The dimension of non-empty
    sets are donated with the maximum number of dimensions of the intersection.
 
    - EMPTY: (-1) for empty collections
    - ZERO:  (0)  for Points and Point collections
    - ONE:   (1)  for Curve types and Curve collections
    - TWO:   (2)  for Surface types and Surface collection
 */
public enum Dimension : Int {
    
    case empty = -1
    case zero = 0
    case one  = 1
    case two  = 2
}


extension Dimension : Comparable {}

public func ==(lhs: Dimension, rhs: Dimension) -> Bool {
    return lhs.rawValue == rhs.rawValue
}

public func <(lhs: Dimension, rhs: Dimension) -> Bool {
    return lhs.rawValue < rhs.rawValue
}


