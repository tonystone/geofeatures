/**
*   GFLineString+Protected.hpp
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
*   Created by Tony Stone on 9/7/15.
*/
#pragma once

#ifndef __GFLineStringProtected_hpp
#define __GFLineStringProtected_hpp

#import <Foundation/Foundation.h>
#import <GeoFeatures/internal/geofeatures/LineString.hpp>
#import "GFLineString.h"

namespace geofeatures {
    // Forward declarations
    class LineString;
}

@interface GFLineString (Protected)

    /**
     * Initialize this GFLineString with an internal LineString implementation.
     */
    - (instancetype) initWithCPPLineString: (geofeatures::LineString) aLineString;

    - (const geofeatures::LineString &) cppConstLineStringReference;

@end

namespace geofeatures {

    namespace GFLineString {

        /**
         * @returns geofeatures::LineString represented by the GeoJSON coordinates
         */
        geofeatures::LineString lineStringWithGeoJSONCoordinates(NSArray * coordinates);

        /**
         * @returns the GeoJSON Geometry for the geofeatures::LineString
         */
        NSDictionary * geoJSONGeometryWithLineString(const geofeatures::LineString & linestring);

        /**
         * @returns the GeoJSON coordinates for the geofeatures::LineString
         */
        NSArray * geoJSONCoordinatesWithLineString(const geofeatures::LineString & lineString);

        /**
         * @returns An object that implements the MKOverlay protocol that represents the geofeatures::LineString
         */
        id <MKOverlay> mkOverlayWithLineString(const geofeatures::LineString & lineString);
    }
}


#endif // __GFLineStringProtected_hpp