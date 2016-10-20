/*
 *   Coordinate.swift
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
 *   Created by Tony Stone on 2/21/16.
 */
import Swift

/**
    Coordinate (2 dimensional protocol)
 
    Implenented by all Coordinate structs.
*/
public protocol Coordinate : Equatable, Hashable, CopyConstructable  {
    
    var x: Double { get }
    var y: Double { get }
}

/**
    3D
 
    Implenented if this Coordinate has z value.
*/
public protocol ThreeDimensional {
    
    var z: Double { get }
}

/**
    Measured
 
    Implenented if this Coordinate has m value.
*/
public protocol Measured {
    
    var m: Double { get }
}
