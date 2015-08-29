/*
*   GFMultiPolygon.mm
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

#import "GFMultiPolygon.h"
#import <MapKit/MapKit.h>

#include "GFGeometry+Protected.hpp"
#include "GFPolygonAbstract+Protected.hpp"

#include "geofeatures/internal/MultiPolygon.hpp"
#include "geofeatures/internal/GeometryVariant.hpp"

#include <vector>

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures::internal;

@implementation GFMultiPolygon

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            gf::MultiPolygon multiPolygon;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], multiPolygon);

            return [super initWithCPPGeometryVariant: multiPolygon];

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
        //
        // Note: Coordinates of a MultiPolygon are an
        // array of Polygon coordinate arrays:
        //
        //
        //  { "type": "MultiPolygon",
        //       "coordinates": [
        //            [
        //              [[102.0, 2.0], [103.0, 2.0], [103.0, 3.0], [102.0, 3.0], [102.0, 2.0]]
        //            ],
        //            [
        //              [[100.0, 0.0], [101.0, 0.0], [101.0, 1.0], [100.0, 1.0], [100.0, 0.0]],
        //              [[100.2, 0.2], [100.8, 0.2], [100.8, 0.8], [100.2, 0.8], [100.2, 0.2]]
        //            ]
        //         ]
        //  }
        //
        gf::MultiPolygon multiPolygon;

        try {
            for (NSArray * polygon in coordinates) {
                multiPolygon.push_back([self cppPolygonWithGeoJSONCoordinates: polygon]);
            }

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return [super initWithCPPGeometryVariant: multiPolygon];
    }

    - (NSDictionary *)toGeoJSONGeometry {
        NSMutableArray * polygons = [[NSMutableArray alloc] init];

        try {
            const gf::MultiPolygon & multiPolygon = gf::strict_get<gf::MultiPolygon>(_intd);

            for (gf::MultiPolygon::vector::const_iterator it = multiPolygon.begin();  it != multiPolygon.end(); ++it ) {
                [polygons addObject: [self geoJSONCoordinatesWithCPPPolygon: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @{@"type": @"MultiPolygon", @"coordinates": polygons};
    }

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];
        
        try {
            const gf::MultiPolygon & multiPolygon = gf::strict_get<gf::MultiPolygon>(_intd);

            for (gf::MultiPolygon::vector::const_iterator it = multiPolygon.begin();  it != multiPolygon.end(); ++it ) {
                [mkPolygons addObject:[self mkOverlayWithCPPPolygon: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolygons;
    }

@end
