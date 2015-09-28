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
#pragma once

#ifndef __GFGeometryProtected_hpp
#define __GFGeometryProtected_hpp

#import <Foundation/Foundation.h>
#import "GFGeometry.h"

#include "GFPoint+Protected.hpp"
#include "GFBox+Protected.hpp"
#include "GFLineString+Protected.hpp"
#include "GFRing+Protected.hpp"
#include "GFPolygon+Protected.hpp"
#include "GFMultiPoint+Protected.hpp"
#include "GFMultiLineString+Protected.hpp"
#include "GFMultiPolygon+Protected.hpp"
#include "GFGeometryCollection+Protected.hpp"

#include "internal/geofeatures/GeometryVariant.hpp"

namespace gf = geofeatures;

@interface GFGeometry (Protected)

    - (instancetype) initWithWKT: (NSString *) wkt;

    - (gf::GeometryVariant)    cppGeometryVariant;
    - (gf::GeometryPtrVariant) cppGeometryPtrVariant;

@end

namespace geofeatures {

    /** static_visitor to transform the variant type to an ObjC type
     *
     */
    class GFInstanceFromVariant : public  boost::static_visitor<GFGeometry *> {

        //
        // Note: The scope-resolution operator (::) on the Objective-C classes
        //       is required when the classes are used at this level to avoid
        //       a clash with the name space of the same name at this level.
        //

    public:
        template <typename T>
        GFGeometry * operator()(const T & v) const {
            return nil;
        }
        GFGeometry * operator()(const Point & v) const {
            return [[::GFPoint alloc] initWithCPPPoint: v];
        }
        GFGeometry * operator()(const MultiPoint & v) const {
            return [[::GFMultiPoint alloc] initWithCPPMultiPoint: v];
        }
        GFGeometry * operator()(const Box & v) const {
            return [[::GFBox alloc] initWithCPPBox: v];
        }
        GFGeometry * operator()(const LineString & v) const {
            return [[::GFLineString alloc] initWithCPPLineString: v];
        }
        GFGeometry * operator()(const Ring & v) const {
            return [[::GFRing alloc] initWithCPPRing: v];
        }
        GFGeometry * operator()(const MultiLineString & v) const {
            return [[::GFMultiLineString alloc] initWithCPPMultiLineString: v];
        }
        GFGeometry * operator()(const Polygon & v) const {
            return [[::GFPolygon alloc] initWithCPPPolygon: v];
        }
        GFGeometry * operator()(const MultiPolygon & v) const {
            return [[::GFMultiPolygon alloc] initWithCPPMultiPolygon: v];
        }
        GFGeometry * operator()(const GeometryCollection<> & v) const {
            return [[::GFGeometryCollection alloc] initWithCPPGeometryCollection: v];
        }
    };
}

#endif // __GFGeometryProtected_hpp