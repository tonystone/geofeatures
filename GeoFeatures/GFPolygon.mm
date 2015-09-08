/*
*   GFPolygon.mm
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

#import "GFPolygon.h"
#import "GFRing.h"
#import <MapKit/MapKit.h>

#include "GFGeometry+Protected.hpp"
#include "GFPolygon+Primitives.hpp"

#include "geofeatures/internal/Polygon.hpp"
#import "GFGeometryCollection.h"

#include <boost/geometry/io/wkt/wkt.hpp>


namespace gf = geofeatures::internal;

namespace geofeatures {
    namespace internal {

        class AddGeometry : public  boost::static_visitor<void> {

        public:
            inline AddGeometry(gf::GeometryCollection & geometryCollection) : geometryCollection(geometryCollection) {}

            template <typename T>
            void operator()(const T & v) const {
                geometryCollection.push_back(v);
            }

            void operator()(const gf::GeometryCollection & v)  const {
                ;   // Do nothing
            }

        private:
            gf::GeometryCollection & geometryCollection;
        };
    }
}

/**
 * @class       GFPolygon
 *
 * @brief       Main implementation for GFPolygon.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */
@implementation GFPolygon

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::Polygon()];
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            gf::Polygon polygon;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], polygon);

            self = [super initWithCPPGeometryVariant: polygon];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        id coordinates = jsonDictionary[@"coordinates"];

        if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
            @throw [NSException exceptionWithName:@"Invalid GeoJSON" reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
        }

        self = [super initWithCPPGeometryVariant: gf::GFPolygon::polygonWithGeoJSONCoordinates(coordinates)];
        return self;
    }

    - (GFRing *) outerRing {
        GFRing * ring = nil;

        try {
            const auto& polygon = boost::polymorphic_strict_get<gf::Polygon>(_members->geometryVariant);

            ring = [[GFRing alloc] initWithCPPGeometryVariant: polygon.outer()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return ring;
    }

    - (GFGeometryCollection *) innerRings {
        GFGeometryCollection * innerRings = nil;

        try {
            const auto& polygon = boost::polymorphic_strict_get<gf::Polygon>(_members->geometryVariant);
            const auto& inners  = polygon.inners();

            gf::GeometryCollection geometryCollection;

            for (auto it = inners.begin(); it != inners.end(); ++it) {
                geometryCollection.push_back(*it);
            }

            innerRings = [[GFGeometryCollection alloc] initWithCPPGeometryVariant: geometryCollection];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return innerRings;
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return @{@"type": @"Polygon", @"coordinates": gf::GFPolygon::geoJSONCoordinatesWithPolygon(boost::polymorphic_strict_get <gf::Polygon>(_members->geometryVariant))};
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFPolygon::mkOverlayWithPolygon(boost::polymorphic_strict_get <gf::Polygon>(_members->geometryVariant))];
    }

@end

