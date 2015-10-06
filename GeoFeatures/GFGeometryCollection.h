/*
 *   GFGeometryCollection.h
 *
 *   Copyright 2015 The Climate Corporation
 *   Copyright 2015 Tony Stone
 *
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
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
 *   Created by Tony Stone on 6/5/15.
 *
 *   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
 *
 */
#import <Foundation/Foundation.h>
#import "GFGeometry.h"

/**
 * @class       GFGeometryCollection
 *
 * @brief       A container class containing an array of GFGeometry objects.
 *
 * @author      Tony Stone
 * @date        6/5/15
 */
@interface GFGeometryCollection : GFGeometry  // <NSFastEnumeration>

    /**
     * Initialize this geometry with the given WKT (Well-Known-Text) string.
     *
     * Example:
     * @code
     * {
     *
     *   NSString * wkt = @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))";
     *
     *   GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: wkt]];
     *
     * }
     * @endcode
     */
    - (instancetype) initWithWKT:(NSString *)wkt;

    /**
     * Initialize this GFGeometryCollection with the given GeoJSON dictionary.
     *
     * @note
     * @parblock
     *
     * Example:
     *
     * @code
     *       {
     *          "type": "GeometryCollection",
     *          "geometries": [
     *               { "type": "Point",
     *                 "coordinates": [100.0, 0.0]
     *               },
     *               { "type": "LineString",
     *                 "coordinates": [ [101.0, 0.0], [102.0, 1.0] ]
     *               }
     *           ]
     *       }
     * @endcode
     * @endparblock
     */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /**
     *
     * Initialize this GFGeometryCollection with the NSArray of GFGeometry instances.
     */
    - (instancetype)initWithArray:(NSArray *)array;

    /** The number of GFGeometry instances in this collection.
     *
     * @returns The count of GDGeometry instances this collection contains.
     */
    - (NSUInteger) count;

    /** Returns the GFGeometry located at the specified index.
     *
     * @param index - An index within the bounds of the collection.
     *
     * @returns The GFGeometry located at index.
     *
     * @throws NSException, NSRangeException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.0.0
     */
    - (id) geometryAtIndex: (NSUInteger) index;

    /** The first GFGeometry in this collection.
     *
     * @returns The first GFGeometry instances contained in this collection or nil if the container is empty.
     *
     * @since 1.0.0
     */
    - (id) firstGeometry;

    /** The last GFGeometry in this collection.
     *
     * @returns The last GFGeometry instances contained in this collection or nil if the container is empty.
     *
     * @since 1.0.0
     */
    - (id) lastGeometry;

    /** Returns the GFGeometry at the specified index.
     *
     * @param index An index within the bounds of the collection.
     *
     * @returns The GFGeometry located at index.
     *
     * Example:
     *
     * @code
     * {
     *    GFGeometryCollection * geometryCollection = [[GFGeometryCollection alloc] initWithWKT: @"GEOMETRYCOLLECTION(POLYGON((120 0,120 90,210 90,210 0,120 0)),LINESTRING(40 50,40 140))"];
     *
     *    GFGeometry * geometry = geometryCollection[0];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.1.0
     */
    - (id) objectAtIndexedSubscript: (NSUInteger) index;

@end

/**
 * @class       GFMutableGeometryCollection
 *
 * @brief       A mutable version of GFGeometryCollection.
 *
 * @author      Tony Stone
 * @date        9/26/15
 */
@interface GFMutableGeometryCollection : GFGeometryCollection

    /** Inserts a given GFGeometry at the end of the GFMutableGeometryCollection.
     *
     * @throws An NSInvalidArgumentException if GFGeometry is nil.
     */
    - (void) addGeometry: (id) aGeometry;

    /** Inserts a given GFGeometry into the GFMutableGeometryCollection’s contents at a given index.
     *
     * @throws An NSRangeException if index is greater than the number of elements in the GFMutableGeometryCollection.
     * @throws An NSInvalidArgumentException if GFGeometry is nil.
     */
    - (void) insertGeometry: (id) aGeometry atIndex: (NSUInteger) index;

    /** Empties the GFMutableGeometryCollection of all its GFGeometries.
     */
    - (void) removeAllGeometries;

    /** Removes the GFGeometry at index.
     *
     * @throws An exception NSRangeException if index is beyond the end of the GFMutableGeometryCollection.
     */
    - (void) removeGeometryAtIndex: (NSUInteger) index;

    /** Sets the GFGeometry at the given index.
     *
     * @param aGeometry The GFGeometry with which to replace the GFGeometry at index in the GFMutableGeometryCollection. This value must not be nil.
     * @param index  The index of the GFGeometry to be replaced. This value must not exceed the bounds of the GFMutableGeometryCollection.
     *
     * Example:
     *
     * @code
     * {
     *    GFMutableGeometryCollection * geometryCollection = [[GFMutableGeometryCollection alloc] init];
     *
     *    geometryCollection[0] = [[GFPolygon alloc] initWithWKT: @"POLYGON((0 0,0 90,90 90,90 0,0 0))"];
     *    geometryCollection[1] = [[GFLineString alloc] initWithWKT: @"LINESTRING(1 1,2 2,3 3)"];
     * }
     * @endcode
     *
     * @throws NSException If index is beyond the end of the collection (that is, if index is greater than or equal to the value returned by count), an NSRangeException is raised.
     *
     * @since 1.3.0
     */
    - (void) setObject: (id) aGeometry atIndexedSubscript:(NSUInteger) index;

@end