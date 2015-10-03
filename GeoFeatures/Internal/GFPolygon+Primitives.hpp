/**
*   GFPolygon+Primitives.hpp
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
*   Created by Tony Stone on 9/3/15.
*/
#pragma once

#ifndef __GFPolygonPrimitives_hpp
#define __GFPolygonPrimitives_hpp

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


namespace geofeatures {

    // Forward declarations
    class Polygon;


    namespace GFPolygon {

        geofeatures::Polygon polygonWithGeoJSONCoordinates(NSArray * coordinates);

        NSArray * geoJSONCoordinatesWithPolygon(const geofeatures::Polygon & polygon);

        id <MKOverlay> mkOverlayWithPolygon(const geofeatures::Polygon & polygon);
    }
}

#endif // __GFPolygonPrimitives_hpp
