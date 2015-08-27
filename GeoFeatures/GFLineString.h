/*
*   GFLineString.h
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
#import "GFLineStringAbstract.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

/**
 * @class       GFLineString
 *
 * @brief       A GFLineString is a collection of GFPoints.
 *
 * @author      Tony Stone
 * @date        6/14/15
 */
@interface GFLineString : GFLineStringAbstract

#pragma clang diagnostic pop

    /**
    * Initialize this geometry with the given WKT (Well-Known-Text) string.
    *
    * Example:
    * @code
    * {
    *
    *   NSString * wkt = @"LINESTRING(40 60,120 110)";
    *
    *   GFLineString * lineString = [[GFLineString alloc] initWithWKT: wkt]];
    *
    * }
    * @endcode
    */
    - (id) initWithWKT:(NSString *)wkt;

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
    - (id)initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary;

@end

