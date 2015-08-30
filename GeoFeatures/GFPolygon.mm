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
#import <MapKit/MapKit.h>

#include "GFGeometry+Protected.hpp"
#include "GFPolygonAbstract+Protected.hpp"

#include "geofeatures/internal/Polygon.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures::internal;

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

        self = [super initWithCPPGeometryVariant: [self cppPolygonWithGeoJSONCoordinates:coordinates]];
        return self;
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return @{@"type": @"Polygon", @"coordinates": [self geoJSONCoordinatesWithCPPPolygon: boost::polymorphic_strict_get<gf::Polygon>(_members->geometryVariant)]};
    }

    - (NSArray *) mkMapOverlays {
        return @[[self mkOverlayWithCPPPolygon: boost::polymorphic_strict_get<gf::Polygon>(_members->geometryVariant)]];
    }

@end

