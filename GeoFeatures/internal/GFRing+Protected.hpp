/**
*   GFRing+Protected.hpp
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
*   Created by Tony Stone on 920/15.
*/
#pragma once

#ifndef __GFRingProtected_hpp
#define __GFRingProtected_hpp

#import <Foundation/Foundation.h>
#import "GFRing.h"

namespace geofeatures {
    //Farward declarations
    class Ring;
}

@interface GFRing (Protected)

    /**
     * Initialize this GFRing with an internal Ring implementation.
     */
    - (instancetype) initWithCPPRing: (geofeatures::Ring) aRing;

    - (const geofeatures::Ring &) cppConstRingReference;

@end

namespace geofeatures {

    namespace GFRing {

        /**
         * @returns geofeatures::Ring represented by the GeoJSON coordinates
         */
        geofeatures::Ring ringWithGeoJSONCoordinates(NSArray * coordinates);

        /**
         * @returns the GeoJSON Geometry for the geofeatures::Ring
         */
        NSDictionary * geoJSONGeometryWithRing(const geofeatures::Ring & ring);

        /**
         * @returns the GeoJSON coordinates for the geofeatures::Ring
         */
        NSArray * geoJSONCoordinatesWithRing(const geofeatures::Ring & ring);

        /**
         * @returns An object that implements the MKOverlay protocol that represents the geofeatures::Ring
         */
        id <MKOverlay> mkOverlayWithRing(const geofeatures::Ring & ring);
    }
}

#endif // __GFRingProtected_hpp