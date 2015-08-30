/*
*   GFGeometryCollection.h
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
    *
    * Initialize this GFGeometryCollection with the NSArray of GFGeometry instances.
    *
    * @warning The array must not contain another GFGeometryCollection instance.
    *
    */
    - (instancetype)initWithArray:(NSArray *)array;

    /**
    * @returns The count of GDGeometry instances this collection contains.
    */
    - (NSUInteger) count;

    /**
    * @returns The GFGeometry instance at the index given.
    */
    - (GFGeometry *) geometryAtIndex:(NSUInteger)index;

    /**
    *
    * @returns The first GFGeometry instances contained in this collection or nil if the container is empty.
    */
    - (GFGeometry *) firstGeometry;

    /**
    *
    * @returns The last GFGeometry instances contained in this collection or nil if the container is empty.
    */
    - (GFGeometry *) lastGeometry;

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