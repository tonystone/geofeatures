/*
*   GFMultiPolygon.h
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
@class GFPolygon;

/**
 * @class       GFMultiPolygon
 *
 * @brief       A collection of GFPolygons.
 *
 * @author      Tony Stone
 * @date        6/14/15
 */
@interface GFMultiPolygon : GFGeometryCollection

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))";
    *
    *   GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: wkt]];
    *
    * }
    * @endcode
    */
    - (instancetype) initWithWKT:(NSString *)wkt;

    /**
    * Initialize this geometry with the given jsonDictionary.
    *
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
    *       "geometry": {
    *                       "type": "MultiPolygon",
    *                       "coordinates": [
    *                            [
    *                               [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]
    *                            ],
    *                            [
    *                               [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
    *                               [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
    *                            ]
    *                       ]
    *                   }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *   {
    *       "type": "MultiPolygon",
    *       "coordinates": [
    *            [
    *              [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]
    *            ],
    *            [
    *              [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
    *              [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
    *            ]
    *         ]
    *  }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /** The number of GFPolygon instances in this collection.
    *
    * @returns The count of GDGeometry instances this collection contains.
    *
    * @since 1.1.0
    */
    - (NSUInteger) count;

    /** Returns the GFPolygon located at the specified index.
    *
    * @param index - An index within the bounds of the collection.
    *
    * @returns The GFPolygon located at index.
    *
    * @throws NSException, NSRangeException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
    *
    * @since 1.1.0
    */
    - (GFPolygon *) geometryAtIndex: (NSUInteger) index;

    /** The first GFPolygon in this collection.
    *
    * @returns The first GFPolygon instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFPolygon *) firstGeometry;

    /** The last GFPolygon in this collection.
    *
    * @returns The last GFPolygon instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFPolygon *) lastGeometry;

    /** Returns the GFPolygon at the specified index.
     *
     * @param index An index within the bounds of the collection.
     *
     * @returns The GFPolygon located at index.
     *
     * Example:
     *
     * @code
     * {
     *    GFMultiPolygon * multiPolygon = [[GFMultiPolygon alloc] initWithWKT: @"MULTIPOLYGON(((20 0,20 10,40 10,40 0,20 0)),((5 5,5 8,8 8,8 5,5 5)))"];
     *
     *    GFPolygon * polygon = multiPolygon[1];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.1.0
     */
    - (GFPolygon *) objectAtIndexedSubscript: (NSUInteger) index;

@end


/**
 * @class       GFMutableMultiPolygon
 *
 * @brief       A mutable version of GFMultiPolygon.
 *
 * @author      Tony Stone
 * @date        9/24/15
 */
@interface GFMutableMultiPolygon : GFMultiPolygon

    /** Inserts a given GFPolygon at the end of the GFMutableMultiPolygon.
     *
     * @throws An NSInvalidArgumentException if GFPolygon is nil.
     */
    - (void) addGeometry: (GFPolygon *) aPolygon;

    /** Inserts a given GFPolygon into the GFMutableMultiPolygon’s contents at a given index.
     *
     * @throws An NSRangeException if index is greater than the number of elements in the GFMutableMultiPolygon.
     * @throws An NSInvalidArgumentException if GFPolygon is nil.
     */
    - (void) insertGeometry: (GFPolygon *) aPolygon atIndex: (NSUInteger) index;

    /** Empties the GFMutableMultiPolygon of all its GFPolygons.
     */
    - (void) removeAllGeometries;

    /** Removes the GFPolygon at index.
     *
     * @throws An exception NSRangeException if index is beyond the end of the GFMutableMultiPolygon.
     */
    - (void) removeGeometryAtIndex: (NSUInteger) index;

    /** Sets the GFPolygon at the given index.
     *
     * @param aPolygon The GFPolygon with which to replace the GFPolygon at index in the GFMutableMultiPolygon. This value must not be nil.
     * @param index  The index of the GFPolygon to be replaced. This value must not exceed the bounds of the GFMutableMultiPolygon.
     *
     * Example:
     *
     * @code
     * {
     *    GFMutableMultiPolygon * multiPolygon = [[GFMutableMultiPolygon alloc] init];
     *
     *    multiPolygon[0] = [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 90,90 90,90 0,0 0))"];
     *    multiPolygon[1] = [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 80,80 80,80 0,0 0))"];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.3.0
     */
    - (void) setObject: (GFPolygon *) aPolygon atIndexedSubscript:(NSUInteger) index;

@end