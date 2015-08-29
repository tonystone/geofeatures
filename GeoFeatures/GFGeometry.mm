/*
*   GFGeometry.mm
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
*   Created by Tony Stone on 4/14/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import "GFGeometry+Protected.hpp"
#import <MapKit/MapKit.h>
#import "NSString+CaseInsensitiveHasPrefix.h"

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
#include "geofeatures/internal/operators/UnionOperation.hpp"
#include "geofeatures/internal/operators/CentroidOperation.hpp"
#include "geofeatures/internal/operators/LengthOperation.hpp"
#include "geofeatures/internal/operators/AreaOperation.hpp"
#include "geofeatures/internal/operators/BoundingBoxOperation.hpp"
#include "geofeatures/internal/operators/PerimeterOperation.hpp"
#include "geofeatures/internal/operators/WKTOperation.hpp"
#include "geofeatures/internal/operators/WithinOperation.hpp"
#include "geofeatures/internal/operators/IsValidOperation.hpp"

#include <memory>

#include <boost/algorithm/string/predicate.hpp>
#include <boost/variant.hpp>
#include <boost/variant/polymorphic_get.hpp>

namespace  gf = geofeatures::internal;

//
// Private methods
//
@interface GFGeometry ()
@end

namespace geofeatures {
    namespace internal {
        namespace detail {

            class GFInstanceFromVariant : public  boost::static_visitor<GFGeometry *> {

            public:
                template <typename T>
                GFGeometry * operator()(const T & v) const {
                    return nil;
                }
                GFGeometry * operator()(const gf::Point & v) const {
                    return [[GFPoint alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::MultiPoint & v) const {
                    return [[GFMultiPoint alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::Box & v) const {
                    return [[GFBox alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::LineString & v) const {
                    return [[GFLineString alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::MultiLineString & v) const {
                    return [[GFMultiLineString alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::Polygon & v) const {
                    return [[GFPolygon alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::MultiPolygon & v) const {
                    return [[GFMultiPolygon alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const gf::GeometryCollection & v) const {
                    return [[GFGeometryCollection alloc] initWithCPPGeometryVariant: v];;
                }
            };
        }
    }
}

@implementation GFGeometry

    - (void)encodeWithCoder:(NSCoder *)coder {
        [coder encodeObject: [self toWKTString] forKey: @"WKT"];
    }

    - (id)initWithCoder:(NSCoder *)coder {
        NSString * wkt = [coder decodeObjectForKey: @"WKT"];
        self = [self initWithWKT: wkt];
        return self;
    }

    - (id) copyWithZone:(struct _NSZone *)zone {
        GFGeometry *copy = (GFGeometry *) [[[self class] allocWithZone:zone] init];

        if (copy != nil) {
            copy->_intd = new GFInternal(self->_intd->geometryVariant);
        }
        return copy;
    }

    - (id) init {
        NSAssert(![[self class] isMemberOfClass: [GFGeometry class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));
        return nil;
    }

    - (BOOL) isValid {
        try {
            return boost::apply_visitor(gf::operators::IsValidOperation(), _intd->geometryVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)area {
        try {
            return boost::apply_visitor(gf::operators::AreaOperation(), _intd->geometryVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)length {
        try {
            return boost::apply_visitor(gf::operators::LengthOperation(), _intd->geometryVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (double)perimeter {
        try {
            return boost::apply_visitor(gf::operators::PerimeterOperation(), _intd->geometryVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *)centroid {
        try {
            return [[GFPoint alloc] initWithCPPGeometryVariant: boost::apply_visitor(gf::operators::CentroidOperation(), _intd->geometryVariant)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFBox *)boundingBox {
        try {
            return [[GFBox alloc] initWithCPPGeometryVariant: boost::apply_visitor(gf::operators::BoundingBoxOperation(), _intd->geometryVariant)];
            
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (BOOL)within:(GFGeometry *)other {

        try {
            return boost::apply_visitor( gf::operators::WithinOperation(), _intd->geometryVariant, other->_intd->geometryVariant);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *)union_: (GFGeometry *)other {
        try {
            gf::GeometryVariant result(boost::apply_visitor( gf::operators::UnionOperation(), _intd->geometryVariant, other->_intd->geometryVariant));

            return boost::apply_visitor(gf::detail::GFInstanceFromVariant(), result);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (NSString *)description {
        return [self toWKTString];
    }

@end

@implementation GFGeometry (Protected)

    - (id) initWithCPPGeometryVariant: (gf::GeometryVariant) geometryVariant {
        NSAssert(![[self class] isMemberOfClass: [GFGeometry class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));

        if ((self = [super init])) {
            _intd = new GFInternal(geometryVariant);
        }
        return self;
    }

    - (void) dealloc {

        if (_intd)
            delete _intd;
    }

    - (id) initWithWKT:(NSString *)wkt {
        @throw [NSException exceptionWithName: @"Must Override" reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo: nil];
        return self;
    }

@end

@implementation GFGeometry (WKT)

    + (GFGeometry *)geometryWithWKT:(NSString *) wkt {

        try {
            if ([wkt hasPrefix: @"GEOMETRYCOLLECTION" caseInsensitive: YES]) {

                return [[GFGeometryCollection alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"POINT" caseInsensitive: YES]) {

                return [[GFPoint alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"MULTIPOINT" caseInsensitive: YES]) {

                return [[GFMultiPoint alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"BOX" caseInsensitive: YES]) {

                return [[GFBox alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"LINESTRING" caseInsensitive: YES]) {

                return [[GFLineString alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"MULTILINESTRING" caseInsensitive: YES]) {

                return [[GFMultiLineString alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"POLYGON" caseInsensitive: YES]) {

                return [[GFPolygon alloc] initWithWKT: wkt];

            } else if ([wkt hasPrefix: @"MULTIPOLYGON" caseInsensitive: YES]) {

                return [[GFMultiPolygon alloc] initWithWKT: wkt];
            }

            return nil;

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (NSString *) toWKTString {
        try {
            std::string wkt = boost::apply_visitor(gf::operators::WKTOperation(), _intd->geometryVariant);

            return [NSString stringWithFormat:@"%s",wkt.c_str()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

@end

@implementation GFGeometry (GeoJSON)

    - (id) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if ((self = [super init])) {
        }
        return self;
    }

    + (GFGeometry *)geometryWithGeoJSONGeometry:(NSDictionary *)geoJSONGeometryDictionary {
        NSParameterAssert(geoJSONGeometryDictionary != nil);

        GFGeometry * geometry = nil;

        Class geometryClass = NSClassFromString([NSString stringWithFormat: @"GF%@", geoJSONGeometryDictionary[@"type"]]);

        if (geometryClass) {
            geometry = [(GFGeometry *)[geometryClass alloc] initWithGeoJSONGeometry: geoJSONGeometryDictionary];
        }
        return geometry;
    }

    - (NSDictionary *)toGeoJSONGeometry {
        @throw [NSException exceptionWithName: @"Must Override" reason: [NSString stringWithFormat: @"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo: nil];
        return nil;
    }

@end

@implementation GFGeometry (MapKit)

    - (NSArray *)mkMapOverlays {
        @throw [NSException exceptionWithName:@"Must Override" reason:[NSString stringWithFormat:@"%@#%@ must be overriden by the subclass.", NSStringFromClass([self class]), NSStringFromSelector(_cmd)] userInfo:nil];
        return nil;
    }

@end




