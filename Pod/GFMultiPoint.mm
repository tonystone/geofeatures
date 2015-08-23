/*
*   GFMultiPoint.mm
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

#import "GFMultiPoint.h"

#include "GFPointAbstract+Protected.hpp"
#include "GFGeometry+Protected.hpp"

#include "geofeatures/internal/MultiPoint.hpp"
#include "geofeatures/internal/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

@implementation GFMultiPoint

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            geofeatures::internal::MultiPoint multiPoint;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], multiPoint);

            return [super initWithCPPGeometryVariant: multiPoint];

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
        // Note: Coordinates of a MultiPoint are an array of positions
        //
        // { "type": "MultiPoint",
        //      "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
        // }
        //
        geofeatures::internal::MultiPoint multiPoint;

        for (NSArray * coordinate in coordinates) {
            multiPoint.push_back([self cppPointWithGeoJSONCoordinates: coordinate]);
        }
        return [super initWithCPPGeometryVariant: multiPoint];
    }

    - (NSDictionary *)toGeoJSONGeometry {
        NSMutableArray * polygons = [[NSMutableArray alloc] init];

        try {
            const geofeatures::internal::MultiPoint & multiPoint = boost::polymorphic_strict_get<geofeatures::internal::MultiPoint>([self cppGeometryConstReference]);

            for (geofeatures::internal::MultiPoint::vector::const_iterator it = multiPoint.begin();  it != multiPoint.end(); ++it ) {
                [polygons addObject: [self geoJSONCoordinatesWithCPPPoint: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @{@"type": @"MultiPolygon", @"coordinates": polygons};
    }

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        try {
            const geofeatures::internal::MultiPoint & multiPoint = boost::polymorphic_strict_get<geofeatures::internal::MultiPoint>([self cppGeometryConstReference]);

            for (geofeatures::internal::MultiPoint::vector::const_iterator it = multiPoint.vector::begin();  it != multiPoint.vector::end(); ++it ) {
                [mkPolygons addObject: [self mkOverlayWithCPPPoint: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolygons;
    }

@end
