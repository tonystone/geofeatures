/*
*   GFPoint.mm
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
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import "GFPoint.h"

#include "GFPointAbstract+Protected.hpp"
#include "GFGeometry+Protected.hpp"

#include "geofeatures/internal/Point.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

/**
 * @class       GFPoint
 *
 * @brief       A brief description.
 *
 * Here typically goes a more extensive explanation of what the header
 * defines. Doxygens tags are words preceeded by either a backslash @\
 * or by an at symbol @@.
 *
 * @author      Tony Stone
 * @date        6/8/15
 */
@implementation GFPoint

    - (id)initWithX:(double)x y:(double)y {
        geofeatures::internal::Point point;

        try {
            point.set<0>(x);
            point.set<1>(y);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }

        return [super initWithCPPGeometryVariant: point];
    }

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            geofeatures::internal::Point point;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], point);

            return [super initWithCPPGeometryVariant: point];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (id)initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {

        id coordinates = jsonDictionary[@"coordinates"];

        if (!coordinates || ![coordinates isKindOfClass: [NSArray  class]]) {
            @throw [NSException exceptionWithName: @"Invalid GeoJSON" reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type."  userInfo: nil];
        }

        return [super initWithCPPGeometryVariant: [self cppPointWithGeoJSONCoordinates: coordinates]];
    }

    - (double) x {
        const geofeatures::internal::Point & point = boost::polymorphic_strict_get<geofeatures::internal::Point>([self cppGeometryConstReference]);

        return point.get<0>();
    }

    - (double) y {
        const geofeatures::internal::Point & point = boost::polymorphic_strict_get<geofeatures::internal::Point>([self cppGeometryConstReference]);

        return point.get<1>();
    }

    - (NSDictionary *)toGeoJSONGeometry {
        const geofeatures::internal::Point & point = boost::polymorphic_strict_get<geofeatures::internal::Point>([self cppGeometryConstReference]);

        return @{@"type": @"Point", @"coordinates": [self geoJSONCoordinatesWithCPPPoint: point]};
    }

    - (NSArray *)mkMapOverlays {
        const geofeatures::internal::Point & point = boost::polymorphic_strict_get<geofeatures::internal::Point>([self cppGeometryConstReference]);

        return @[[self mkOverlayWithCPPPoint: point]];
    }

@end
