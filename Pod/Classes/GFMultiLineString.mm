/*
*   GFMultiLineString.mm
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
*   Created by Tony Stone on 6/4/15.
*/

#import <MapKit/MapKit.h>
#import "GFMultiLineString.h"

#include "MultiLineString.hpp"
#include "GFLineStringAbstract+Protected.hpp"
#include "GFGeometry+Protected.hpp"

#include "GeometryVariant.hpp"
#include <vector>
#include <boost/geometry/io/wkt/wkt.hpp>

@implementation GFMultiLineString

    - (id)initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            climate::gf::MultiLineString multiLineString;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], multiLineString);

            return [super initWithCPPGeometryVariant: multiLineString];

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
        // Coordinates of a MultiLineString are an array of LineString coordinate arrays:
        //
        //  { "type": "MultiLineString",
        //              "coordinates": [
        //                      [ [100.0, 0.0], [101.0, 1.0] ],
        //                      [ [102.0, 2.0], [103.0, 3.0] ]
        //      ]
        //  }
        //
        climate::gf::MultiLineString multiLineString;

        for (NSArray *lineString in coordinates) {
            multiLineString.push_back([self cppLineStringWithGeoJSONCoordinates:lineString]);
        }
        return [super initWithCPPGeometryVariant: multiLineString];
    }

    - (NSDictionary *)toGeoJSONGeometry {
        NSMutableArray * lineStrings = [[NSMutableArray alloc] init];

        try {
            const climate::gf::MultiLineString & multiLineString = boost::polymorphic_strict_get<climate::gf::MultiLineString>([self cppGeometryConstReference]);

            for (climate::gf::MultiLineString::vector::const_iterator it = multiLineString.begin();  it != multiLineString.end(); ++it ) {
                [lineStrings addObject:[self geoJSONCoordinatesWithCPPLineString: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @{@"type": @"MultiLineString", @"coordinates": lineStrings};
    }

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        try {
            const climate::gf::MultiLineString & multiLineString = boost::polymorphic_strict_get<climate::gf::MultiLineString>([self cppGeometryConstReference]);

            for (climate::gf::MultiLineString::vector::const_iterator it = multiLineString.begin();  it != multiLineString.end(); ++it ) {
                [mkPolygons addObject:[self mkOverlayWithCPPLineString: (*it)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolygons;
    }

@end
