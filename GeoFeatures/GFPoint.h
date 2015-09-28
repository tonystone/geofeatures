/*
*   GFPoint.h
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
#import "GFGeometry.h"


//
// Forward declarations
//
@class GFMutablePoint;


/**
* @class       GFPoint
*
* @brief       A 2 dimensional point with x,y coordinates.
*
* @author      Tony Stone
* @date        6/14/15
*/
@interface GFPoint : GFGeometry <NSMutableCopying>

    /**
    * Initialize this GFPoint with the x,y coordinates
    */
    - (instancetype) initWithX: (double) x y: (double) y;

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"POINT(1 1)";
    *
    *   GFPoint * point = [[GFPoint alloc] initWithWKT: wkt]];
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
    *       "geometry": { "type": "Point",
    *                     "coordinates": [100.0, 0.0]
    *                   }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *       {
    *           "type": "Point",
    *           "coordinates": [100.0, 0.0]
    *       }
    * @endcode
    * @endparbloc
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /**
    * Get the point's X value.
    */
    - (double) x;

    /**
    * Get the point's Y value.
    */
    - (double) y;

@end


/**
* @class       GFMutablePoint
*
* @brief       A mutable 2 dimensional point with x,y coordinates.
*
* @author      Tony Stone
* @date        9/10/15
*/
@interface GFMutablePoint : GFPoint

    /**
     * Set the point's X value.
     */
    - (void) setX: (double) x;

    /**
     * Set the point's Y value.
     */
    - (void) setY: (double) y;

@end
