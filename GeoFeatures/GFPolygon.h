/*
*   GFPolygon.h
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
*   Created by Tony Stone on 6/3/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#import <Foundation/Foundation.h>
#import "GFGeometry.h"

// Forward declarations
@class GFRing;
@class GFGeometryCollection;

/**
 * @class       GFPolygon
 *
 * @brief       A concrete Polygon implementation.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */
@interface GFPolygon : GFGeometry

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"POLYGON((0 0,0 90,90 90,90 0,0 0))";
    *
    *   GFPolygon * polygon = [[GFPolygon alloc] initWithWKT: wkt]];
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
    * Given the following JSON:
    * @code
    * {
    *       "type": "Feature",
    *
    *       "geometry": {
    *                       "type": "MultiPolygon",
    *                       "coordinates": [
    *                             [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
    *                        ]
    *                   }
    *  }
    * @endcode
    *
    * You would pass this section to the init method.
    * @code
    *      {
    *           "type": "MultiPolygon",
    *           "coordinates": [
    *                 [ [100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0] ]
    *           ]
    *      }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /** The outer ring of this polygon.
     *
     * @returns The outer GFRing of this polygon.
     */
    - (GFRing *) outerRing;

    /** The inner rings of this polygon.
     *
     * @returns A collection of inner GFRings of this polygon.
     */
    - (GFGeometryCollection *) innerRings;

@end

/**
* @class       GFMutablePolygon
*
* @brief       A a mutable representation of GFPolygon.
*
* @author      Tony Stone
* @date        9/24/15
*/
@interface GFMutablePolygon : GFPolygon

    /**
     * Set the outer GFRing of this GFMutablePolygon.
     */
    - (void) setOuterRing: (GFRing *) outerRing;

    /**
     * Set the inner GFRings of this GFMutablePolygon.
     *
     * @throws An NSInvalidArgumentException if all the Geometries in the collections are not GFRings.
     */
    - (void) setInnerRings: (GFGeometryCollection *) aRingCollection;

@end