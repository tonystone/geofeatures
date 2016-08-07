/**
*   GFBox+Protected.hpp
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

#ifndef __GFBoxProtected_hpp
#define __GFBoxProtected_hpp

#import <Foundation/Foundation.h>
#import "GFBox.h"

namespace geofeatures {
    // Forward declarations
    class Box;
}

@interface GFBox (Protected)

    /**
     * Initialize this GFBox with an internal Box implementation.
     */
    - (instancetype) initWithCPPBox: (geofeatures::Box) aBox;

@end

namespace geofeatures {

    namespace GFBox {

        geofeatures::Box boxWithGeoJSONCoordinates(NSArray * coordinates);

        NSDictionary * geoJSONGeometryWithBox(const geofeatures::Box & box);

        NSArray * geoJSONCoordinatesWithBox(const geofeatures::Box & box);

        id <MKOverlay> mkOverlayWithBox(const geofeatures::Box & box);
    }
}

#endif // __GFBoxProtected_hpp