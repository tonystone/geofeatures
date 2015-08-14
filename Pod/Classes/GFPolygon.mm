/*
*   GFPolygon.mm
*
*   Copyright 2015 The Climate Corporation
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
*/

#import "GFPolygon.h"
#import <MapKit/MapKit.h>

#include "GFGeometry+Protected.hpp"
#include "GFPolygonAbstract+Protected.hpp"

#include "Polygon.hpp"

#include <boost/geometry.hpp>
#include <boost/geometry/io/wkt/wkt.hpp>

/**
 * @class       GFPolygon
 *
 * @brief       Main implementation for GFPolygon.
 *
 * @author      Tony Stone
 * @date        6/6/15
 */

@implementation GFPolygon

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            climate::gf::Polygon polygon;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], polygon);

            return [super initWithCPPGeometryVariant: polygon];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (id)initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        id coordinates = jsonDictionary[@"coordinates"];

        if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
            @throw [NSException exceptionWithName:@"Invalid GeoJSON" reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
        }

        return [super initWithCPPGeometryVariant: [self cppPolygonWithGeoJSONCoordinates:coordinates]];
    }

    - (NSDictionary *)toGeoJSONGeometry {
        return @{@"type": @"Polygon", @"coordinates": [self geoJSONCoordinatesWithCPPPolygon: boost::polymorphic_strict_get<climate::gf::Polygon>([self cppGeometryConstReference])]};
    }

    - (NSArray *)mkMapOverlays {
        return @[[self mkOverlayWithCPPPolygon: boost::polymorphic_strict_get<climate::gf::Polygon>([self cppGeometryConstReference])]];
    }

@end

