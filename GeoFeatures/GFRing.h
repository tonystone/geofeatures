/*
*   GFRing.h
*
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
*   Created by Tony Stone on 08/29/15.
*/
#import <Foundation/Foundation.h>
#import "GFLineString.h"

/**
 * @class       GFRing
 *
 * @brief       A GFRing (aka linear ring) is a closed line which should not be self intersecting.
 *
 * A GFRing is a GFLineString which is closed. The first and last coordinate in the ring
 * must be equal, and the interior of the ring must not self-intersect. A ring must have
 * either 0 or 4 or more GFPoints.  If these conditions are not met, the constructors
 * throw an IllegalArgumentException
 *
 * @author      Tony Stone
 * @date        8/30/15
 */
@interface GFRing : GFLineString 
    /// @see GFLineString for methods

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * @note
    * @parblock
    *
    * WKT does not support rings. However, to be generic GeoFeatures
    * supports reading and writing from and to rings. Rings are read
    * and written as a standard LINESTRING WKT.
    *
    * @endparblock
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"LINESTRING(40 60,120 110)";
    *
    *   GFRing * ring = [[GFRing alloc] initWithWKT: wkt]];
    *
    * }
    * @endcode
    */
    - (instancetype) initWithWKT:(NSString *)wkt;

    /**
    * Initialize this geometry with the given jsonDictionary.
    *
    * @note
    * @parblock
    *
    * GeoJSON does not support rings. However, to be generic GeoFeatures
    * supports reading and writing from and to rings. Rings are read
    * and written as a standard GeoJSON LineString.
    *
    * You must pass the geometry portion of the GeoJSON structure and
    * not the entire GeoJSON object.
    *
    * Example:
    *
    * @code
    * {
    *       "type": "Feature",
    *
    *       "geometry": { "type": "LineString",
    *                     "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
    *                   }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *     {
    *           "type": "LineString",
    *           "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
    *     }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

@end

/**
 * @class       GFMutableRing
 *
 * @brief       A mutable version of GFRing.
 *
 * @author      Tony Stone
 * @date        9/24/15
 */
@interface GFMutableRing : GFRing

    /** Inserts a given GFPoint at the end of the GFMutableRing.
     *
     * @throws An NSInvalidArgumentException if aPoint is nil.
     */
    - (void) addPoint: (GFPoint *) aPoint;

    /** Inserts a given GFPoint into the GFMutableRing’s contents at a given index.
     *
     * @throws An NSRangeException if index is greater than the number of elements in the GFMutableRing.
     * @throws An NSInvalidArgumentException if aPoint is nil.
     */
    - (void) insertPoint: (GFPoint *) aPoint atIndex: (NSUInteger) index;

    /** Empties the GFMutableRing of all its GFPoints.
     */
    - (void) removeAllPoints;

    /** Removes the GFPoint at index.
     *
     * @throws An exception NSRangeException if index is beyond the end of the GFMutableRing.
     */
    - (void) removePointAtIndex: (NSUInteger) index;

    /** Sets the GFPoint at the given index.
     *
     * @param aPoint The GFPoint with which to replace the GFPoint at index in the GFMutableRing. This value must not be nil.
     * @param index  The index of the GFPoint to be replaced. This value must not exceed the bounds of the GFMutableRing.
     *
     * Example:
     *
     * @code
     * {
     *    GFMutableRing * ring = [[GFMutableRing alloc] init];
     *
     *   ring[0] = [[GFPoint alloc] initWithWKT: @"POINT(20 0)"];
     *   ring[1] = [[GFPoint alloc] initWithWKT: @"POINT(20 10)"];
     *   ring[2] = [[GFPoint alloc] initWithWKT: @"POINT(40 10)"];
     *   ring[3] = [[GFPoint alloc] initWithWKT: @"POINT(40 0)"];
     *   ring[4] = [[GFPoint alloc] initWithWKT: @"POINT(20 0)"];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.3.0
     */
    - (void) setObject: (GFPoint *) aPoint atIndexedSubscript:(NSUInteger) index;

@end