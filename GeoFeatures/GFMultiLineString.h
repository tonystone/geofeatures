/*
*   GFMultiLineString.h
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
@class GFLineString;

/**
 * @class       GFMultiLineString
 *
 * @brief       A collection of GFLineStrings.
 *
 * MultiLineString can be used to group lines belonging to each other, e.g. a highway (with interruptions)
 *
 * @author      Tony Stone
 * @date        6/4/15
 */
@interface GFMultiLineString : GFGeometryCollection

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))";
    *
    *   GFMultiLineString * multiLineString = [[GFMultiLineString alloc] initWithWKT: wkt]];
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
    *       "geometry": { "type": "MultiLineString",
    *                     "coordinates": [
    *                               [ [100.0, 0.0], [101.0, 1.0] ],
    *                               [ [102.0, 2.0], [103.0, 3.0] ]
    *                       ]
    *                   }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *       {
    *           "type": "MultiLineString",
    *           "coordinates": [
    *                   [ [100.0, 0.0], [101.0, 1.0] ],
    *                   [ [102.0, 2.0], [103.0, 3.0] ]
    *             ]
    *       }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /** The number of GFLineString instances in this collection.
    *
    * @returns The count of GFLineString instances this collection contains.
    *
    * @since 1.1.0
    */
    - (NSUInteger) count;

    /** Returns the GFLineString located at the specified index.
    *
    * @param index - An index within the bounds of the collection.
    *
    * @returns The GFLineString located at index.
    *
    * @throws NSException, NSRangeException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
    *
    * @since 1.1.0
    */
    - (GFLineString *) geometryAtIndex:(NSUInteger)index;

    /** The first GFLineString in this collection.
    *
    * @returns The first GFLineString instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFLineString *) firstGeometry;

    /** The last GFLineString in this collection.
    *
    * @returns The last GFLineString instances contained in this collection or nil if the container is empty.
    *
    * @since 1.1.0
    */
    - (GFLineString *) lastGeometry;

    /** Returns the GFLineString at the specified index.
     *
     * @param index An index within the bounds of the collection.
     *
     * @returns The GFLineString located at index.
     *
     * Example:
     *
     * @code
     * {
     *    GFMultiLineString * multiLineString = [[GFMultiLineString alloc] initWithWKT: @"MULTILINESTRING((0 0,5 0),(5 0,10 0,5 -5,5 0),(5 0,5 5))"];
     *
     *    GFLineString * lineString = multiLineString[1];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.1.0
     */
    - (GFLineString *) objectAtIndexedSubscript: (NSUInteger) index;

@end

/**
 * @class       GFMutableMultiLineString
 *
 * @brief       A mutable version of GFMultiLineString.
 *
 * @author      Tony Stone
 * @date        9/24/15
 */
@interface GFMutableMultiLineString : GFMultiLineString

    /** Inserts a given GFLineString at the end of the GFMutableMultiLineString.
     *
     * @throws An NSInvalidArgumentException if GFLineString is nil.
     */
    - (void) addGeometry: (GFLineString *) aLineString;

    /** Inserts a given GFLineString into the GFMutableMultiLineString’s contents at a given index.
     *
     * @throws An NSRangeException if index is greater than the number of elements in the GFMutableMultiLineString.
     * @throws An NSInvalidArgumentException if GFLineString is nil.
     */
    - (void) insertGeometry: (GFLineString *) aLineString atIndex: (NSUInteger) index;

    /** Empties the GFMutableMultiLineString of all its GFLineStrings.
     */
    - (void) removeAllGeometries;

    /** Removes the GFLineString at index.
     *
     * @throws An exception NSRangeException if index is beyond the end of the GFMutableMultiLineString.
     */
    - (void) removeGeometryAtIndex: (NSUInteger) index;

    /** Sets the GFLineString at the given index.
     *
     * @param aLineString The GFLineString with which to replace the GFLineString at index in the GFMutableMultiLineString. This value must not be nil.
     * @param index  The index of the GFLineString to be replaced. This value must not exceed the bounds of the GFMutableMultiLineString.
     *
     * Example:
     *
     * @code
     * {
     *    GFMutableMultiLineString * multiLineString = [[GFMutableMultiLineString alloc] init];
     *
     *    multiLineString[0] = [[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2,3 3)"];
     *    multiLineString[1] = [[GFLineString alloc] initWithWKT: @"LINESTRING(2 2,103 1)"];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.3.0
     */
    - (void) setObject: (GFLineString *) aLineString atIndexedSubscript:(NSUInteger) index;

@end

