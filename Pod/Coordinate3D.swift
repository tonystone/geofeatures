/*
 *   Coordinate3D.swift
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
 *   Created by Tony Stone on 2/9/16.
 */
import Swift

/**
 3D Coordinate
 
 Low level 3 dimensional Coorodinate type
 */
public typealias Coordinate3D = (x: Double, y: Double, z: Double)

//: Mark: Equatable

internal func coordinateEquals<T : protocol<Comparable, FloatingPointType>>(tuple1: (T,T,T), _ tuple2: (T,T,T), dimension: Int) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1) && (dimension == 3 ? (tuple1.2 == tuple2.2) : true)
}

internal func coordinateEquals<T : protocol<Comparable, IntegerType>>(tuple1: (T,T,T), _ tuple2: (T,T,T), dimension: Int) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1) && (dimension == 3 ? (tuple1.2 == tuple2.2) : true)
}

//: Mark: Math

internal func coordinateAdd(tuple1: (Double,Double,Double), _ tuple2: (Double,Double,Double), dimension: Int) -> (Double,Double,Double)  {
    return (tuple1.0 + tuple2.0, tuple1.1 + tuple2.1, (dimension == 3 ? tuple1.2 + tuple2.2 : Double.NaN))
}

internal func coordinateAdd(tuple1: (Int,Int,Int), _ tuple2: (Int,Int,Int), dimension: Int) -> (Int,Int,Int)  {
    return (tuple1.0 + tuple2.0, tuple1.1 + tuple2.1, (dimension == 3 ? tuple1.2 + tuple2.2 : 0))
}

internal func coordinateSubtract(tuple1: (Double,Double,Double), _ tuple2: (Double,Double,Double), dimension: Int) -> (Double,Double,Double) {
    return (tuple1.0 - tuple2.0, tuple1.1 - tuple2.1, (dimension == 3 ? tuple1.2 - tuple2.2 : Double.NaN))
}

internal func coordinateSubtract(tuple1: (Int,Int,Int), _ tuple2: (Int,Int,Int), dimension: Int) -> (Int,Int,Int) {
    return (tuple1.0 - tuple2.0, tuple1.1 - tuple2.1, (dimension == 3 ? tuple1.2 - tuple2.2 : 0))
}
