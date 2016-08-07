/**
*   GFPoint+Protected.hpp
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
*   Created by Tony Stone on 9/6/15.
*/
#pragma once

#ifndef __GFPointProtected_hpp
#define __GFPointProtected_hpp

#import <Foundation/Foundation.h>
#import "GFPoint.h"

namespace geofeatures {
    // Forward declarations
    class Point;
}

@interface GFPoint (Protected)

    /**
     * Initialize this GFPoint with an internal Point implementation.
     */
    - (instancetype) initWithCPPPoint: (geofeatures::Point) aPoint;

    - (const geofeatures::Point &) cppConstPointReference;

@end

namespace geofeatures {

    namespace GFPoint {

        geofeatures::Point pointWithGeoJSONCoordinates(NSArray * coordinates);

        NSDictionary * geoJSONGeometryWithPoint(const geofeatures::Point & point);

        NSArray * geoJSONCoordinatesWithPoint(const geofeatures::Point & point);

        id <MKOverlay> mkOverlayWithPoint(const geofeatures::Point & point);
    }
}

#endif // __GFPointProtected_hpp