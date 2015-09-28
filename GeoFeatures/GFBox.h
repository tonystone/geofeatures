/*
*   GFBox.h
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
*  MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#import <Foundation/Foundation.h>
#import "GFGeometry.h"

// Forward declarations
@class GFPoint;

/**
* @class       GFBox
*
* @brief       GFBox represents a simple box geometry.
*
* The GFBox class represents a simple box geometry and is
* represented as min and max corner GFPoints.
*
* @author      Tony Stone
* @date        6/4/15
*/
@interface GFBox : GFGeometry

    /**
    * Initialize this GFBox with 2 points representing the min and max point in the box.
    */
    - (instancetype) initWithMinCorner: (GFPoint *) minCorner maxCorner: (GFPoint *) maxCorner;

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * @note
    * @parblock
    *
    * WKT does not support boxes. However, to be generic GeoFeatures
    * supports reading and writing from and to boxes. Boxes are outputted as a
    * standard POLYGON WKT.
    *
    * GeoFeatures can read boxes from a standard POLYGON,
    * from a POLYGON with 2 points or from a BOX
    *
    * The WKT output will always be a POLYGON
    * @endparblock
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"POLYGON((0 0,0 90,90 90,90 0,0 0))";
    *
    *   GFBox * box = [[GFBox alloc] initWithWKT: wkt]];
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
    *       "geometry":  {
    *           "type": "Box",
    *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
    *       }
    *  }
    * @endcode
    *
    * In the above example only the dictionary below that
    * represents the geometry portion is passed.
    *
    * @code
    *       {
    *           "type": "Box",
    *           "coordinates": [[100.0, 0.0], [101.0, 1.0]]
    *       }
    * @endcode
    * @endparblock
    */
    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

    /**
    * @returns The minCorner GFPoint from this GFBox
    */
    - (GFPoint *) minCorner;

    /**
    * @return The maxCorner GFPoint from this GFBox
    */
    - (GFPoint *) maxCorner;

@end

/**
* @class       GFMutableBox
*
* @brief       GFMutableBox represents a mutable GFBox.
*
* @author      Tony Stone
* @date        9/23/15
*/
@interface GFMutableBox : GFBox

    /**
     * Set the minCorner GFPoint of this GFMutableBox.
     */
    - (void) setMinCorner: (GFPoint *) minCorner;

    /**
     * Set the maxCorner GFPoint of this GFMutableBox
     */
    - (void) setMaxCorner: (GFPoint *) maxCorner;

@end