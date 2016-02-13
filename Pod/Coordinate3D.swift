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

func == <T: protocol<Equatable, FloatingPointType>> (tuple1:(T,T,T),tuple2:(T,T,T)) -> Bool {
    return (tuple1.0 == tuple2.0) && (tuple1.1 == tuple2.1) && (tuple1.2.isNaN && tuple2.2.isNaN ? true : (tuple1.2 == tuple2.2))
}

func != <T: protocol<Comparable, FloatingPointType>> (tuple1:(T,T,T),tuple2:(T,T,T)) -> Bool {
    return (tuple1.0 != tuple2.0) || (tuple1.1 != tuple2.1) || (tuple1.2.isNaN && tuple2.2.isNaN ? false : (tuple1.2 != tuple2.2))
}

//: Mark: Math

func +(tuple1:(Double,Double,Double),tuple2:(Double,Double,Double)) -> (Double,Double,Double)  {
    return (tuple1.0 + tuple2.0, tuple1.1 + tuple2.1, tuple1.2.isNaN || tuple2.2.isNaN ? Double.NaN : tuple1.2 + tuple2.2)
}

func - (tuple1:(Double,Double,Double),tuple2:(Double,Double,Double)) -> (Double,Double,Double) {
    return (tuple1.0 - tuple2.0, tuple1.1 - tuple2.1, tuple1.2.isNaN || tuple2.2.isNaN ? Double.NaN : tuple1.2 - tuple2.2)
}
