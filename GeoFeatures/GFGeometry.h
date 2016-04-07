/*
*   GFGeometry.h
*
*   Copyright 2015 The Climate Corporation
*   Copyright 2015 Tony Stone
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
*   Created by Tony Stone on 4/14/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//
// Forward declarations
//
@class GFPoint;
@class GFBox;

NS_ASSUME_NONNULL_BEGIN

/**
 * @class       GFGeometry
 *
 * @brief       An abstract class that represents a geometric shape.
 *
 * GFGeometry is the abstract base class for all geometry subclasses.  It is also the central
 * factory object for creation of geometries.
 *
 * @warning Do not instantiate this abstract class.
*
 * @author      Tony Stone
 * @date        6/14/15
 */
@interface GFGeometry : NSObject <NSCoding, NSCopying, NSMutableCopying>

    /** Checks if a geometry is valid.
    */
    - (BOOL) isValid;

    /**
     *
     * The area algorithm calculates the surface area of all geometries having a surface,
     * namely box, polygon, ring, multipolygon. The units are the square of the units used
     * for the points defining the surface. If subject geometry is defined in meters, then
     * area is calculated in square meters
     *
     * @returns The area of the geometry.
     */
    - (double) area __attribute__((swift_private, availability(swift, unavailable, message="Use area() throws -> Double instead.")));

    /**
     *
     * The area algorithm calculates the surface area of all geometries having a surface,
     * namely box, polygon, ring, multipolygon. The units are the square of the units used
     * for the points defining the surface. If subject geometry is defined in meters, then
     * area is calculated in square meters
     *
     * @returns The area of the geometry.
     */
    - (double) area: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("area()"), swift_error(nonnull_error)));

    /** The length method calculates the length (the sum of distances between consecutive points) of a geometry.
     *
     * @note
     * @parblock
     *
     *   point types (e.g. GFPoint) Return zero
     *
     *   linear types (e.g. GFLineString) Return the length
     *
     *   areal (e.g. GFPolygon)  Return zero
     *
     * @endparblcok
     *
     * @returns The length of linear GFGeometry types (e.g. GFLineString).
     */
    - (double) length __attribute__((swift_private, availability(swift, unavailable, message="Use length() throws -> Double instead.")));

    /** The length method calculates the length (the sum of distances between consecutive points) of a geometry.
     *
     * @note
     * @parblock
     *
     *   point types (e.g. GFPoint) Return zero
     *
     *   linear types (e.g. GFLineString) Return the length
     *
     *   areal (e.g. GFPolygon)  Return zero
     *
     * @endparblcok
     *
     * @returns The length of linear GFGeometry types (e.g. GFLineString).
     */
    - (double) length: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("length()"), swift_error(nonnull_error)));

    /** Calculates the perimeter of a geometry
     *
     * @note
     *  @parblock
     *
     *  point types (e.g. GFPoint) Returns zero
     *
     *  linear types (e.g. GFLineString) Returns zero
     *
     *  areal (e.g. GFPolygon)  Returns the perimeter
     *
     *  @endparblock
     *
     *  @returns The perimeter of areal GFGeometry types (e.g. GFPolygon).
     */
    - (double) perimeter __attribute__((swift_private, availability(swift, unavailable, message="Use perimeter() throws -> Double instead.")));

    /** Calculates the perimeter of a geometry
     *
     * @note
     *  @parblock
     *
     *  point types (e.g. GFPoint) Returns zero
     *
     *  linear types (e.g. GFLineString) Returns zero
     *
     *  areal (e.g. GFPolygon)  Returns the perimeter
     *
     *  @endparblock
     *
     *  @returns The perimeter of areal GFGeometry types (e.g. GFPolygon).
     */
    - (double) perimeter: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("perimeter()"), swift_error(nonnull_error)));

    /**  The centroid method calculates the geometric center (or: center of mass) of a geometry.
     *
     * @returns The calculated centroid as a GFPoint.
     */
    - (GFPoint *) centroid __attribute__((swift_private, availability(swift, unavailable, message="Use centroid() throws -> GFPoint instead.")));

    /**  The centroid method calculates the geometric center (or: center of mass) of a geometry.
     *
     * @returns The calculated centroid as a GFPoint.
     */
    - (GFPoint *) centroid: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("centroid()"), swift_error(nonnull_error)));

    /** The boundingBox method calculates the boundingBox (also known as axis aligned bounding box, aabb, or minimum bounding rectangle, mbr) of a geometry.
     *
     * @returns The bounding box as a GFBox.
     */
    - (GFBox *) boundingBox __attribute__((swift_private, availability(swift, unavailable, message="Use boundingBox() throws -> GFBox instead.")));

    /** The boundingBox method calculates the boundingBox (also known as axis aligned bounding box, aabb, or minimum bounding rectangle, mbr) of a geometry.
     *
     * @returns The bounding box as a GFBox.
     */
    - (GFBox *) boundingBox: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("boundingBox()"), swift_error(nonnull_error)));

    /** Checks if the geometry is completely inside the other geometry.
     *
     * @returns True if self is within the other GFGeometry instance.  False otherwise.
     */
    - (BOOL) within: (GFGeometry *) other __attribute__((swift_private, availability(swift, unavailable, message="Use within(other: GFGeometry) throws -> Bool instead.")));

    /** Checks if the geometry is completely inside the other geometry.
     *
     * @returns True if self is within the other GFGeometry instance.  False otherwise.
     */
    - (BOOL) within: (GFGeometry *) other error: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("within(other:)"), swift_error(nonnull_error)));

    /**
     * Checks if self has at least one intersection.
     *
     * @returns true if self has at least one intersection.
     */
    - (BOOL) intersects __attribute__((swift_private, availability(swift, unavailable, message="Use intersects() throws -> Bool instead.")));

    /**
     * Checks if self has at least one intersection.
     *
     * @returns true if self has at least one intersection.
     */
    - (BOOL) intersectsError: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("intersects()"), swift_error(nonnull_error)));

    /**
     * Checks if self has at least one intersection with the other geometry.
     *
     * @returns true if self has at least one intersection with the other geometry.
     */
    - (BOOL) intersects: (GFGeometry *) other __attribute__((swift_private, availability(swift, unavailable, message="Use intersects() throws -> Bool instead.")));

    /**
     * Checks if self has at least one intersection with the other geometry.
     *
     * @returns true if self has at least one intersection with the other geometry.
     */
    - (BOOL) intersects: (GFGeometry *) other error: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("intersects(other:)"), swift_error(nonnull_error)));

    /** Combines the other geometry with self. The union calculates the spatial set theoretic union of the two geometries.
     *
     * @returns A new GFGeometry instance that represents the union of the self and other.
     *
     * @throws NSInvalidArgumentException if the one of the geometries is invalid.  You can test for an invalid geometry by calling isValid.
     */
    - (GFGeometry *) union_: (GFGeometry *)other __attribute__((swift_private, availability(swift, unavailable, message="Use union(other: GFGeometry) throws -> GFGeometry instead.")));

    /** Combines the other geometry with self. The union calculates the spatial set theoretic union of the two geometries.
     *
     * @returns A new GFGeometry instance that represents the union of the self and other.
     */
    - (GFGeometry *) union_: (GFGeometry *)other error: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("union(other:)"), swift_error(nonnull_error)));

@end

/**
* @category    GFGeometry(WKT)
*
* @brief       WKT (well-known-text) interface to GFGeometry.
*
* @author      Tony Stone
* @date        6/14/15
*/
@interface GFGeometry (WKT)

    /** Create a GFGeometry instance from the WKT string.
     *
     * @param wkt an NSString wkt representation of the geometry
     *
     * Example 1:
     * @code
     * {
     *
     *   NSString * wkt = @"POLYGON((0 0,0 90,90 90,90 0,0 0))";
     *
     *   GFGeometry * geometry = [GFGeometry geometryWithWKT: wkt]];
     *
     * }
     * @endcode
     *
     * Example 2:
     * @code
     * {
     *
     *   NSString * wkt = @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))";
     *
     *   GFGeometry * geometry = [GFGeometry geometryWithWKT: wkt]];
     *
     * }
     * @endcode
     *
     */
    + (instancetype) geometryWithWKT:(NSString *)wkt __attribute__((swift_private, availability(swift, unavailable, message="Use init(wkt: String) throws -> GFGeometry instead.")));

    /** Create a GFGeometry instance from the WKT string.
     *
     * @param wkt an NSString wkt representation of the geometry
     *
     * Example 1:
     * @code
     * {
     *
     *   NSString * wkt = @"POLYGON((0 0,0 90,90 90,90 0,0 0))";
     *
     *   GFGeometry * geometry = [GFGeometry geometryWithWKT: wkt]];
     *
     * }
     * @endcode
     *
     * Example 2:
     * @code
     * {
     *
     *   NSString * wkt = @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))";
     *
     *   GFGeometry * geometry = [GFGeometry geometryWithWKT: wkt]];
     *
     * }
     * @endcode
     *
     */
    + (instancetype) geometryWithWKT:(NSString *)wkt error: (NSError * __autoreleasing * _Nullable) error __attribute__((swift_name("init(wkt:)"), swift_error(nonnull_error)));

    /**
     *
     * @returns A WKT string representation of this GFGeometry.
     */
    - (NSString *) toWKTString;

@end

/**
* @category    GFGeometry(GeoJSON)
*
* @brief       GeoJSON interface to GFGeometry.
*
* @author      Tony Stone
* @date        6/14/15
*/
@interface GFGeometry (GeoJSON)

    /** Creates a GFGeometry from the GeoJSON dictionary supplied.
     *
     * @note  You must pass the geometry portion of the GeoJSON structure and not the entire GeoJSON object.
     * @parblock
     *
     * Given the following GeoJSON:
     * @code
     * {
     *       "type": "Feature",
     *
     *       "geometry":  {
     *           "type": "Box",
     *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
     *       }
     *  }
     * @endcode
     *
     * You would pass the geometry section below to the init method.
     * @code
     *       {
     *           "type": "Box",
     *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
     *       }
     * @endcode
     * @endparblock
     *
     * Example:
     * @code
     * {
     *     NSString * jsonString = @"{ \"type\": \"Polygon\","
     *                              "    \"coordinates\": ["
     *                              "      [ [100.0, 0.0], [200.0, 0.0], [200.0, 100.0], [100.0, 1.0], [100.0, 0.0] ],"
     *                              "      [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]"
     *                              "      ]"
     *                              "   }"
     *
     *     NSDictionary * geometryDictionary = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil];
     *
     *     GFGeometry * geometry = [GFGeometry geometryWithGeoJSONGeometry: geometryDictionary ]
     *
     * }
     * @endcode
     *
     *
     * @throws NSException This method will throw an exception if the geo json is invalid.
     */
    + (instancetype) geometryWithGeoJSONGeometry: (NSDictionary *) geoJSONGeometryDictionary __attribute__((swift_private, availability(swift, unavailable, message="Use init(geoJSONGeometry: [NSObject : AnyObject]) throws -> GFGeometry instead.")));


    /** Creates a GFGeometry from the GeoJSON dictionary supplied.
     *
     * @note  You must pass the geometry portion of the GeoJSON structure and not the entire GeoJSON object.
     * @parblock
     *
     * Given the following GeoJSON:
     * @code
     * {
     *       "type": "Feature",
     *
     *       "geometry":  {
     *           "type": "Box",
     *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
     *       }
     *  }
     * @endcode
     *
     * You would pass the geometry section below to the init method.
     * @code
     *       {
     *           "type": "Box",
     *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
     *       }
     * @endcode
     * @endparblock
     *
     * Example:
     * @code
     * {
     *     NSString * jsonString = @"{ \"type\": \"Polygon\","
     *                              "    \"coordinates\": ["
     *                              "      [ [100.0, 0.0], [200.0, 0.0], [200.0, 100.0], [100.0, 1.0], [100.0, 0.0] ],"
     *                              "      [ [100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2] ]"
     *                              "      ]"
     *                              "   }"
     *
     *     NSDictionary * geometryDictionary = [NSJSONSerialization JSONObjectWithData: [jsonString dataUsingEncoding: NSUTF8StringEncoding] options: 0 error: nil];
     *
     *     GFGeometry * geometry = [GFGeometry geometryWithGeoJSONGeometry: geometryDictionary ]
     *
     * }
     * @endcode
     *
     *
     * @throws NSException This method will throw an exception if the geo json is invalid.
     */
    + (instancetype) geometryWithGeoJSONGeometry:(NSDictionary *)geoJSONGeometryDictionary error: (NSError * __autoreleasing *) error __attribute__((swift_name("init(geoJSONGeometry:)"), swift_error(nonnull_error)));

    /** Converts the Geometry to a GeoJSON object.
    *
    * @throws NSException
    *
    * @returns A NSDictionary GeoJSON representation of self.
    */
    - (NSDictionary *) toGeoJSONGeometry;

@end

/**
* @category    GFGeometry(MapKit)
*
* @brief       Apple MapKit methods for GFGeometry.
*
* @author      Tony Stone
* @date        6/14/15
*/
@interface GFGeometry (MapKit)

    /**
    *
    * @returns An array of map overlay objects that represent this geometry.  These can be placed directly on a MapKit map.
    */
    - (NSArray *) mkMapOverlays;

@end

NS_ASSUME_NONNULL_END

