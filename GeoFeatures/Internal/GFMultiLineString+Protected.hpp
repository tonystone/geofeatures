/**
*   GFMultiLineString+Protected.hpp
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

#ifndef __GFMultiLineStringProtected_hpp
#define __GFMultiLineStringProtected_hpp

#import <Foundation/Foundation.h>
#import "GFMultiLineString.h"

namespace geofeatures {
    // Forward declarations
    class MultiLineString;
}

namespace  gf = geofeatures;

@interface GFMultiLineString (Protected)

    /**
     * Initialize this GFMultiLineString with an internal MultiLineString implementation.
     */
    - (instancetype) initWithCPPMultiLineString: (gf::MultiLineString) aMultiLineString;

    /**
     * @returns A reference to the internal MultiLineString implementation.
     */
    - (gf::MultiLineString &) cppMultiLineStringReference;

    /**
     * @returns A reference to the internal MultiLineString implementation.
     */
    - (const gf::MultiLineString &) cppMultiLineStringConstReference;

@end

#endif // __GFMultiLineStringProtected_hpp