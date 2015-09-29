/*
*   GFMultiPoint.h
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
*   Created by Tony Stone on 6/4/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#import <Foundation/Foundation.h>
#import "GFGeometryCollection.h"

// Forward declarations
@class GFPoint;

/**
 * @class       GFMultiPoint
 *
 * @brief       A collection of GFPoints
 *
 * @author      Tony Stone
 * @date        6/14/15
 */
@interface GFMultiPoint : GFGeometryCollection

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"MULTIPOINT((1 1),(2 2))";
    *
    *   GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: wkt]];
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
    * You must pass the geometry portion of the GeoJSON structure and
    * not the entire GeoJSON object.
    *
    * Example:
    *
    * @code
    * {
    *       "type": "Feature",
    *
    *       "geometry": { "type": "MultiPoint",
    *                     "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
    *                   }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *       {
    *           "type": "MultiPoint",
    *           "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
    *       }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /** The number of GFPoint instances in this collection.
    *
    * @returns The count of GDGeometry instances this collection contains.
    *
    * @since 1.1.0
    */
    - (NSUInteger) count;

    /** Returns the GFPoint located at the specified index.
    *
    * @param index - An index within the bounds of the collection.
    *
    * @returns The GFPoint located at index.
    *
    * @throws NSException, NSRangeException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
    *
    * @since 1.1.0
    */
    - (GFPoint *) geometryAtIndex: (NSUInteger) index;

    /** The first GFPoint in this collection.
    *
    * @returns The first GFPoint instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFPoint *) firstGeometry;

    /** The last GFPoint in this collection.
    *
    * @returns The last GFPoint instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFPoint *) lastGeometry;

    /** Returns the point at the specified index.
     *
     * @param index An index within the bounds of the collection.
     *
     * @returns The point located at index.
     *
     * Example:
     *
     * @code
     * {
     *    GFMultiPoint * multiPoint = [[GFMultiPoint alloc] initWithWKT: @"MULTIPOINT((1 1),(2 2))"];
     *
     *    GFPoint * point1 = multiPoint[0];
     *    GFPoint * point2 = multiPoint[1];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.1.0
     */
    - (GFPoint *) objectAtIndexedSubscript: (NSUInteger) index;

@end


/**
 * @class       GFMutableMultiPoint
 *
 * @brief       A mutable version of GFMultiPoint.
 *
 * @author      Tony Stone
 * @date        9/24/15
 */
@interface GFMutableMultiPoint : GFMultiPoint

    /** Inserts a given GFPoint at the end of the GFMutableMultiPoint.
     *
     * @throws An NSInvalidArgumentException if aPoint is nil.
     */
    - (void) addGeometry: (GFPoint *) aPoint;

    /** Inserts a given GFPoint into the GFMutableMultiPoint’s contents at a given index.
     *
     * @throws An NSRangeException if index is greater than the number of elements in the GFMutableMultiPoint.
     * @throws An NSInvalidArgumentException if aPoint is nil.
     */
    - (void) insertGeometry: (GFPoint *) aPoint atIndex: (NSUInteger) index;

    /** Empties the GFMutableMultiPoint of all its GFPoints.
     */
    - (void) removeAllGeometries;

    /** Removes the GFPoint at index.
     *
     * @throws An exception NSRangeException if index is beyond the end of the GFMutableMultiPoint.
     */
    - (void) removeGeometryAtIndex: (NSUInteger) index;

    /** Sets the GFPoint at the given index.
     *
     * @param aPoint The GFPoint with which to replace the GFPoint at index in the GFMutableMultiPoint. This value must not be nil.
     * @param index  The index of the GFPoint to be replaced. This value must not exceed the bounds of the GFMutableMultiPoint.
     *
     * Example:
     *
     * @code
     * {
     *    GFMutableMultiPoint * multiPoint = [[GFMutableMultiPoint alloc] init];
     *
     *    multiPoint[0] = [[GFPoint alloc] initWithWKT: @"POINT(1 1)"];
     *    multiPoint[1] = [[GFPoint alloc] initWithWKT: @"POINT(2 2)"];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.3.0
     */
    - (void) setObject: (GFPoint *) aPoint atIndexedSubscript:(NSUInteger) index;

@end