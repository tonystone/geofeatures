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
#import "GFLineString.h"

namespace geofeatures {
    // Forward declarations
    class LineString;
}

namespace  gf = geofeatures;

@interface GFLineString (Protected)

    /**
     * Initialize this GFLineString with an internal LineString implementation.
     */
    - (instancetype) initWithCPPLineString: (gf::LineString) aLineString;

    /**
     * @returns A reference to the internal LineString implementation.
     */
    - (gf::LineString &) cppLineStringReference;

    /**
     * @returns A reference to the internal LineString implementation.
     */
    - (const gf::LineString &) cppLineStringConstReference;

@end

#endif // __GFLineStringProtected_hpp