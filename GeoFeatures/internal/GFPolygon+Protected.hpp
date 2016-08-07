/**
*   GFPolygon+Protected.hpp
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

#ifndef __GFPolygonProtected_hpp
#define __GFPolygonProtected_hpp

#import <Foundation/Foundation.h>
#import "GFPolygon.h"

namespace geofeatures {
    // Forward declarations
    class Polygon;
}

@interface GFPolygon (Protected)

    /**
     * Initialize this GFPolygon with an internal Polygon implementation.
     */
    - (instancetype) initWithCPPPolygon: (geofeatures::Polygon) aPolygon;

    - (const geofeatures::Polygon &) cppConstPolygonReference;

@end

namespace geofeatures {

    namespace GFPolygon {

        geofeatures::Polygon polygonWithGeoJSONCoordinates(NSArray * coordinates);

        NSDictionary * geoJSONGeometryWithPolygon(const geofeatures::Polygon & polygon);

        NSArray * geoJSONCoordinatesWithPolygon(const geofeatures::Polygon & polygon);

        id <MKOverlay> mkOverlayWithPolygon(const geofeatures::Polygon & polygon);
    }
}

#endif // __GFPolygonProtected_hpp