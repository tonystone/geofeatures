/*
 *   GeometryType.swift
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
 *   Created by Tony Stone on 2/5/16.
 */
import Swift

/**
GeometryType

A protocol that represents a geometric shape. GeometryType
is the abstract type that is implenented by all geometry classes.
*/
public protocol GeometryType {

    var dimension: Int { get }
    var precision: Precision { get }
    var coordinateReferenceSystem: CoordinateReferenceSystem { get }
    
    func isEmpty() -> Bool

    func equals(other: GeometryType) -> Bool
    
//    func isSimple() -> Bool
    
//    func envelop() -> Polygon
//    
//    //: ## Algorythms
//    //: Query
//    /**
//    - Returns: true if this geometric object is “spatially disjoint” from the other Geometry.
//    */
//    func disjoint(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially intersects” the other Geometry.
//     */
//    func intersects(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially touches” the other Geometry.
//     */
//    func touches(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially crosses’ the other Geometry.
//     */
//    func crosses(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object is “spatially within” the other Geometry.
//     */
//    func within(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially contains” the other Geometry
//     */
//    func contains(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially overlaps” the other Geometry.
//     */
//    func overlaps(other: GeometryType) -> Bool
//    
//    /**
//     - Returns true if this geometric object is spatially related to the other Geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.
//     - Returns: false if all the tested intersections are empty except exterior (this) intersect exterior (another).
//     */
//    func relate(other: GeometryType, matrix :String) -> Bool
//    
//    /**
//     - Returns: A derived geometry collection value that matches the specified m coordinate value.
//     */
//    func locateAlong(mValue :Double) -> GeometryType
//    
//    /**
//     - Returns: A derived geometry collection value that matches the specified range of m coordinate values inclusively.
//     */
//    func locateBetween(mStart :Double, mEnd :Double) -> GeometryType
//    
//    //: Analysis
//    //public func distance(geometry: GeometryType, other: GeometryType) -> Distance
//    //public func buffer(distance :Distance) : GeometryType
//    func convexHull() -> GeometryType
//    
//    func intersection(other: GeometryType) -> GeometryType
//    
    func union(other: GeometryType) ->  GeometryType
//
//    func difference(other: GeometryType) -> GeometryType
//    
//    func symDifference(other: GeometryType) -> GeometryType
}

// MARK: Operators

@warn_unused_result
public func ==(lhs: GeometryType, rhs: GeometryType) -> Bool {
    return lhs.equals(rhs)
}

@warn_unused_result
public func !=(lhs: GeometryType, rhs: GeometryType) -> Bool {
    return !lhs.equals(rhs)
}