/**
*   GFMultiPolygon+Protected.hpp
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

#ifndef __GFMultiPolygonProtected_hpp
#define __GFMultiPolygonProtected_hpp

#import <Foundation/Foundation.h>
#import "GFMultiPolygon.h"

namespace geofeatures {
    // Forward declarations
    class MultiPolygon;
}

namespace  gf = geofeatures;

@interface GFMultiPolygon (Protected)

    /**
     * Initialize this GFMultiPolygon with an internal MultiPolygon implementation.
     */
    - (instancetype) initWithCPPMultiPolygon: (gf::MultiPolygon) aMultiPolygon;

    /**
     * @returns A reference to the internal MultiPolygon implementation.
     */
    - (gf::MultiPolygon &) cppMultiPolygonReference;

    /**
     * @returns A reference to the internal MultiPolygon implementation.
     */
    - (const gf::MultiPolygon &) cppMultiPolygonConstReference;

@end

#endif // __GFMultiPolygonProtected_hpp