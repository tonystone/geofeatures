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
Default Precision for all class
*/
let defaultPrecision = FloatingPrecision()

/**
Default CoordinateReferenceSystem
*/
let defaultCoordinateReferenceSystem = Cartesian()

/**
 GeometryType

 A protocol that represents a geometric shape. GeometryType
 is the abstract type that is implenented by all geometry classes.
*/
public protocol GeometryType {

    /**
        The dimension of this GeometryType which must be equal to or less than the coordinate dimension.
    */
    var dimension: Int { get }
    
    /**
        The Precision used to store the coordinates for this GeometryType
    */
    var precision: Precision { get }
    
    /**
        The Coordinate Reference System used in algorithms applied to this GeoemetryType
    */
    var coordinateReferenceSystem: CoordinateReferenceSystem { get }
    
    /**
     - Returns true if this GeometryType is an empty Geometry.
    */
    @warn_unused_result
    func isEmpty() -> Bool

    /**
     - Returns: true if this GeoemetryType instance is equal the other GeometryType instance.
     */
    @warn_unused_result
    func ==(lhs: GeometryType, rhs: GeometryType) -> Bool
    
    /**
     - Returns: true if this GeoemetryType instance is not equal the other GeometryType instance.
     */
    @warn_unused_result
    func !=(lhs: GeometryType, rhs: GeometryType) -> Bool
    
    /**
     - Returns: true if this GeoemetryType instance is equal the other GeometryType instance.
    */
    @warn_unused_result
    func equals(other: GeometryType) -> Bool
    
//    /**
//     - Returns:  true if this GeoemetryType instance has no anomalous geometric points, such
//     as self intersection or self tangency.
//    */
//    @warn_unused_result
//    func isSimple() -> Bool
//    
//    /**
//     The minimum bounding box for this GeometryType, returned as a GeometryType (Polygon).
//    */
//    @warn_unused_result
//    func envelop() -> GeometryType
//    
//    //: ## Algorythms
//    //: Query
//    /**
//    - Returns: true if this geometric object is “spatially disjoint” from the other Geometry.
//    */
//    @warn_unused_result
//    func disjoint(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially intersects” the other Geometry.
//     */
//    @warn_unused_result
//    func intersects(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially touches” the other Geometry.
//     */
//    @warn_unused_result
//    func touches(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially crosses’ the other Geometry.
//     */
//    @warn_unused_result
//    func crosses(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object is “spatially within” the other Geometry.
//     */
//    @warn_unused_result
//    func within(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially contains” the other Geometry
//     */
//    @warn_unused_result
//    func contains(other: GeometryType) -> Bool
//    
//    /**
//     - Returns: true if this geometric object “spatially overlaps” the other Geometry.
//     */
//    @warn_unused_result
//    func overlaps(other: GeometryType) -> Bool
//    
//    /**
//     - Returns true if this geometric object is spatially related to the other Geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.
//     - Returns: false if all the tested intersections are empty except exterior (this) intersect exterior (another).
//     */
//    @warn_unused_result
//    func relate(other: GeometryType, matrix :String) -> Bool
//    
//    /**
//     - Returns: A derived geometry collection value that matches the specified m coordinate value.
//     */
//    @warn_unused_result
//    func locateAlong(mValue :Double) -> GeometryType
//    
//    /**
//     - Returns: A derived geometry collection value that matches the specified range of m coordinate values inclusively.
//     */
//    @warn_unused_result
//    func locateBetween(mStart :Double, mEnd :Double) -> GeometryType
//    
//    //: Analysis
//    //public func distance(geometry: GeometryType, other: GeometryType) -> Distance
//    //public func buffer(distance :Distance) : GeometryType
//    @warn_unused_result
//    func convexHull() -> GeometryType
//    
//    @warn_unused_result
//    func intersection(other: GeometryType) -> GeometryType
   
    @warn_unused_result
    func union(other: GeometryType) ->  GeometryType

//    @warn_unused_result
//    func difference(other: GeometryType) -> GeometryType
//    
//    @warn_unused_result
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