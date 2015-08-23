/**
*   GFGeometry+Protected.hpp
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
*   Created by Tony Stone on 6/3/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#ifndef __GFGeometryProtected_hpp
#define __GFGeometryProtected_hpp

#import <Foundation/Foundation.h>
#import "GFGeometry.h"

#include "geofeatures/internal/GeometryVariant.hpp"

@interface GFGeometry (Protected)

    - (id) initWithCPPGeometryVariant: (geofeatures::internal::GeometryVariant) geometryVariant;

    - (const geofeatures::internal::GeometryVariant &)cppGeometryConstReference;
    - (geofeatures::internal::GeometryVariant &)cppGeometryReference;

    - (id)initWithWKT:(NSString *)wkt;

@end

#endif // __GFGeometryProtected_hpp