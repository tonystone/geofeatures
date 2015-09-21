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
#include "GFPolygon+Protected.hpp"
#include "GFPolygon+Primitives.hpp"
#include "GFRing+Protected.hpp"
#include "GFGeometryCollection+Protected.hpp"

#include "internal/geofeatures/Polygon.hpp"
#include "internal/geofeatures/GeometryCollection.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

/**
 * @class       GFPolygon
 *
 * @brief       Main implementation for GFPolygon.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */
@implementation GFPolygon {
        gf::Polygon _polygon;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _polygon);

            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: @"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo: nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {
            id coordinates = jsonDictionary[@"coordinates"];

            if (!coordinates || ![coordinates isKindOfClass: [NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo: nil];
            }
            _polygon = gf::GFPolygon::polygonWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

    - (GFRing *) outerRing {
        return [[GFRing alloc] initWithCPPRing: _polygon.outer()];
    }

    - (GFGeometryCollection *) innerRings {
        gf::GeometryCollection geometryCollection;

        const auto& inners  = _polygon.inners();

        for (auto it = inners.begin(); it != inners.end(); ++it) {
            geometryCollection.push_back(*it);
        }
        return [[GFGeometryCollection alloc] initWithCPPGeometryCollection: geometryCollection];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return @{@"type": @"Polygon", @"coordinates": gf::GFPolygon::geoJSONCoordinatesWithPolygon(_polygon)};
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFPolygon::mkOverlayWithPolygon(_polygon)];
    }

@end

@implementation GFPolygon (Protected)

    - (instancetype) initWithCPPPolygon: (gf::Polygon) aPolygon {

        if (self = [super init]) {
            _polygon = aPolygon;
        }
        return self;
    }

    - (gf::Polygon &) cppPolygonReference {
        return _polygon;
    }

    - (const gf::Polygon &) cppPolygonConstReference {
        return _polygon;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_polygon);
    }

@end

