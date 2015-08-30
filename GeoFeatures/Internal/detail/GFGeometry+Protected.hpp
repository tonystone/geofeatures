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
#import "GFPoint.h"
#import "GFMultiPoint.h"
#import "GFBox.h"
#import "GFLineString.h"
#import "GFMultiLineString.h"
#import "GFPolygon.h"
#import "GFMultiPolygon.h"
#import "GFGeometryCollection.h"

#include "geofeatures/internal/Geometry.hpp"
#include "geofeatures/internal/GeometryVariant.hpp"


@interface GFGeometry (Protected)

    - (instancetype) initWithCPPGeometryVariant: (geofeatures::internal::GeometryVariant) geometryVariant;

    - (instancetype) initWithWKT: (NSString *) wkt;

@end

/*
 * @Note GFMembers structure is intentionally in the global namespace
 */
struct GFMembers {
    public:
        GFMembers(geofeatures::internal::GeometryVariant aGeometryVariant) : geometryVariant(aGeometryVariant) {};

        geofeatures::internal::GeometryVariant geometryVariant;
};

namespace geofeatures {
    namespace internal {

        /** static_visitor to transform the variant type to an ObjC type
         *
         */
        class GFInstanceFromVariant : public  boost::static_visitor<GFGeometry *> {

        public:
            template <typename T>
            GFGeometry * operator()(const T & v) const {
                return nil;
            }
            GFGeometry * operator()(const Point & v) const {
                return [[GFPoint alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const MultiPoint & v) const {
                return [[GFMultiPoint alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const Box & v) const {
                return [[GFBox alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const LineString & v) const {
                return [[GFLineString alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const MultiLineString & v) const {
                return [[GFMultiLineString alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const Polygon & v) const {
                return [[GFPolygon alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const MultiPolygon & v) const {
                return [[GFMultiPolygon alloc] initWithCPPGeometryVariant: v];;
            }
            GFGeometry * operator()(const GeometryCollection & v) const {
                return [[GFGeometryCollection alloc] initWithCPPGeometryVariant: v];;
            }
        };

    }
}

#endif // __GFGeometryProtected_hpp