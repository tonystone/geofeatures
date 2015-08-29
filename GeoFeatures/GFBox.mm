/*
*   GFBox.mm
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
*   Created by Tony Stone on 6/4/15.
*
*  MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import "GFBox.h"
#import "GFPoint.h"
#import "GFPolygon.h"

#include "GFPointAbstract+Protected.hpp"
#include "GFGeometry+Protected.hpp"

#include "geofeatures/internal/Box.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures::internal;

/**
 * @class       GFBox
 *
 * @brief       Box is used to define are square for things like bounding boxes of other geometric shapes.
 *
 * @author      Tony Stone
 * @date        6/8/15
 */
@implementation GFBox

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::Box()];
        return self;
    }

    - (id)initWithMinCorner:(GFPoint *) minCorner maxCorner:(GFPoint *) maxCorner {
        try {
            gf::Box box;

            box.minCorner().set<0>([minCorner x]);
            box.minCorner().set<1>([minCorner y]);

            box.maxCorner().set<0>([minCorner x]);
            box.maxCorner().set<1>([minCorner y]);

            return [super initWithCPPGeometryVariant: box];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            gf::Box box;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], box);

            return [super initWithCPPGeometryVariant: box];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (id)initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {

        try {

            id coordinates = jsonDictionary[@"coordinates"];

            if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
                @throw [NSException exceptionWithName:@"Invalid GeoJSON" reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
            }

            /*
             * Coordinates of a Box are an array of two Point coordinates. The first
             * element in the array represents the minimum corner point (minx, miny).
             * The second element in the array represents the maximum corner point (maxx, maxy).
             *
             *  {
             *      "type": "Box",
             *      "coordinates": [[100.0, 0.0], [101.0, 1.0]]
             *  }
             */
            gf::Point minCorner([coordinates[0][0] doubleValue], [coordinates[0][1] doubleValue]);
            gf::Point maxCorner([coordinates[1][0] doubleValue], [coordinates[1][1] doubleValue]);

            return [super initWithCPPGeometryVariant: gf::Box(minCorner, maxCorner)];

        } catch (std::exception &e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) minCorner {
        return [[GFPoint alloc] initWithCPPGeometryVariant: boost::polymorphic_strict_get<gf::Box>(_members->geometryVariant).minCorner()];
    }

    - (GFPoint *) maxCorner {

        return [[GFPoint alloc] initWithCPPGeometryVariant: boost::polymorphic_strict_get<gf::Box>(_members->geometryVariant).maxCorner()];
    }

    - (NSDictionary *)toGeoJSONGeometry {

        try {
            const gf::Box & box = boost::polymorphic_strict_get<gf::Box>(_members->geometryVariant);

            double minCornerX = box.minCorner().get<0>();
            double minCornerY = box.minCorner().get<1>();
            double maxCornerX = box.maxCorner().get<0>();
            double maxCornerY = box.maxCorner().get<1>();

            return @{@"type": @"Box", @"coordinates": @[@[@(minCornerX),@(minCornerY)],@[@(maxCornerX),@(maxCornerY)]]};

        } catch (std::exception &e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (NSArray *)mkMapOverlays {
        const gf::Box & box = boost::polymorphic_strict_get<gf::Box>(_members->geometryVariant);

        CLLocationCoordinate2D coordinates[5];

        coordinates[0].longitude = box.minCorner().get<0>();
        coordinates[0].latitude  = box.minCorner().get<1>();

        coordinates[1].longitude = box.maxCorner().get<0>();
        coordinates[1].latitude  = box.minCorner().get<1>();

        coordinates[2].longitude = box.maxCorner().get<0>();
        coordinates[2].latitude  = box.maxCorner().get<1>();

        coordinates[3].longitude = box.minCorner().get<0>();
        coordinates[3].latitude  = box.maxCorner().get<1>();

        coordinates[4].longitude = box.minCorner().get<0>();
        coordinates[4].latitude  = box.minCorner().get<1>();

        return @[[MKPolygon polygonWithCoordinates:coordinates count:5]];
    }

@end
