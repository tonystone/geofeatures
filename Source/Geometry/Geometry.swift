/*
 *   Geometry.swift
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
public let defaultPrecision = FloatingPrecision()

/**
Default CoordinateReferenceSystem
*/
public let defaultCoordinateReferenceSystem = Cartesian()

/**
 Geometry

 A protocol that represents a geometric shape. Geometry
 is the abstract type that is implenented by all geometry classes.
*/
public protocol Geometry {
    
    /**
        The Precision used to store the coordinates for this Geometry
    */
    var precision: Precision { get }
    
    /**
        The Coordinate Reference System used in algorithms applied to this GeoemetryType
    */
    var coordinateReferenceSystem: CoordinateReferenceSystem { get }
    
    /**
        The inherent dimension of this Geoemetry.
    */
    var dimension: Dimension { get }
    
    /**
     - Returns true if this Geometry is an empty Geometry.
    */
    @warn_unused_result
    func isEmpty() -> Bool

    /**
     - Returns: true if this GeoemetryType instance is equal the other Geometry instance.
     */
    @warn_unused_result
    func ==(lhs: Geometry, rhs: Geometry) -> Bool
    
    /**
     - Returns: true if this GeoemetryType instance is not equal the other Geometry instance.
     */
    @warn_unused_result
    func !=(lhs: Geometry, rhs: Geometry) -> Bool
    
//    /**
//     - Returns:  true if this GeoemetryType instance has no anomalous geometric points, such
//     as self intersection or self tangency.
//    */
//    @warn_unused_result
//    func isSimple() -> Bool
//    
//    /**
//     The minimum bounding box for this Geometry, returned as a Geometry (Polygon).
//    */
//    @warn_unused_result
//    func envelop() -> Geometry
    
    //: ## Algorythms
    //: Predicates
    
    /**
     - Returns: true if this GeoemetryType instance is equal the other Geometry instance.
     */
    @warn_unused_result
    func equals(_ other: Geometry) -> Bool
    
    /**
    - Returns: true if this geometric object is “spatially disjoint” from the other Geometry.
    */
    @warn_unused_result
    func disjoint(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object “spatially intersects” the other Geometry.
     */
    @warn_unused_result
    func intersects(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object “spatially touches” the other Geometry.
     - Returns: false is self and other are both 0-Dimensional (Point and MultiPoint)
     */
    @warn_unused_result
    func touches(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object “spatially crosses’ the other Geometry.
     */
    @warn_unused_result
    func crosses(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object is “spatially within” the other Geometry.
     */
    @warn_unused_result
    func within(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object “spatially contains” the other Geometry
     */
    @warn_unused_result
    func contains(_ other: Geometry) -> Bool
    
    /**
     - Returns: true if this geometric object “spatially overlaps” the other Geometry.
     */
    @warn_unused_result
    func overlaps(_ other: Geometry) -> Bool
    
    /**
     - Returns true if this geometric object is spatially related to the other Geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.
     - Returns: false if all the tested intersections are empty except exterior (this) intersect exterior (another).
     */
    @warn_unused_result
    func relate(_ other: Geometry, pattern :String) -> Bool
//
//    /**
//     - Returns: A derived geometry collection value that matches the specified m coordinate value.
//     */
//    @warn_unused_result
//    func locateAlong(mValue :Double) -> Geometry
//    
//    /**
//     - Returns: A derived geometry collection value that matches the specified range of m coordinate values inclusively.
//     */
//    @warn_unused_result
//    func locateBetween(mStart :Double, mEnd :Double) -> Geometry
//    
//    //: Analysis
//    @warn_unused_result
//    public func distance(other: Geometry) -> Distance
//
//    @warn_unused_result
//    public func buffer(distance :Distance) : Geometry
//
//    @warn_unused_result
//    func convexHull() -> Geometry
//    
//    @warn_unused_result
//    func intersection(other: Geometry) -> Geometry
   
    @warn_unused_result
    func union(_ other: Geometry) ->  Geometry

//    @warn_unused_result
//    func difference(other: Geometry) -> Geometry
//    
//    @warn_unused_result
//    func symDifference(other: Geometry) -> Geometry
}

// MARK: Operators

@warn_unused_result
public func ==(lhs: Geometry, rhs: Geometry) -> Bool {
    return lhs.equals(rhs)
}

@warn_unused_result
public func !=(lhs: Geometry, rhs: Geometry) -> Bool {
    return !lhs.equals(rhs)
}

/**
    Predicate implementation for `Geometry` protocol
 
    - note: In the comments below P is used to refer to 0-dimensional geometries (Points and MultiPoints),\
            L is used to refer to 1-dimensional geometries (LineStrings and MultiLineStrings) and A is used\
            to refer to 2-dimensional geometries (Polygons and MultiPolygons).
 */
extension Geometry {
    
    @warn_unused_result
    func equals(_ other: Geometry) -> Bool {
        return relate(other, pattern: "TFFFTFFFT")
    }
    
    @warn_unused_result
    public
    func disjoint(_ other: Geometry) -> Bool {
        return relate(other, pattern: "FF*FF****")
    }
    
    @warn_unused_result
    public
    func intersects(_ other: Geometry) -> Bool {
        return !disjoint(other)
    }
    
    @warn_unused_result
    public
    func touches(_ other: Geometry) -> Bool {
        
        if self.dimension == .ZERO && other.dimension == .ZERO {
            return false
        }
        return relate(other, pattern: "FT*******") || relate(other, pattern: "F**T*****") || relate(other, pattern: "F***T****")
    }
    
    @warn_unused_result
    public
    func crosses(_ other: Geometry) -> Bool {
        
        if self.dimension == .ZERO && other.dimension == .ONE ||
           self.dimension == .ZERO && other.dimension == .TWO ||
           self.dimension == .ONE  && other.dimension == .TWO {
            
            return relate(other, pattern: "T*T******")
            
        } else if self.dimension == .ONE && other.dimension == .ONE {
            
            return relate(other, pattern: "0********")
        }
        return false
    }
    
    @warn_unused_result
    public
    func within(_ other: Geometry) -> Bool {
        return relate(other, pattern: "T*F**F***")
    }
    
    @warn_unused_result
    public
    func contains(_ other: Geometry) -> Bool {
        return other.within(self)
    }

    @warn_unused_result
    public
    func overlaps(_ other: Geometry) -> Bool {
        
        if self.dimension == .ZERO && other.dimension == .ZERO ||
           self.dimension == .TWO  && other.dimension == .TWO {

            return relate(other, pattern: "T*T***T**")
            
        } else if self.dimension == .ONE && other.dimension == .ONE {
            
            return relate(other, pattern: "1*T***T**")
        }
        return false
    }
    
    @warn_unused_result
    public
    func relate(_ other: Geometry, pattern :String) -> Bool {
        var matrix = calculateIntersectionMatrix(other)
        
        return matrix.matches(pattern: pattern)
    }
    
    private
    func calculateIntersectionMatrix(_ other: Geometry) -> IntersectionMatrix {
        var matrix = IntersectionMatrix()
        
        return matrix
    }
}