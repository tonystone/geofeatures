/*
*   GFMultiLineString.mm
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

#import <MapKit/MapKit.h>
#import "GFMultiLineString.h"
#import "GFLineString.h"

#include "GFLineString+Primitives.hpp"
#include "GFGeometry+Protected.hpp"

#include "geofeatures/internal/MultiLineString.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

#include <vector>

namespace gf = geofeatures::internal;

@implementation GFMultiLineString

#pragma mark - Construction

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::MultiLineString()];
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            gf::MultiLineString multiLineString;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], multiLineString);

            self = [super initWithCPPGeometryVariant: multiLineString];

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
        gf::MultiLineString multiLineString;

        try {
            for (NSArray * lineString in coordinates) {
                multiLineString.push_back(gf::GFLineString::lineStringWithGeoJSONCoordinates(lineString));
            }

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }

        self = [super initWithCPPGeometryVariant: multiLineString];
        return self;
    }

#pragma mark - Querying a GFMultiLineString

    - (NSUInteger) count {
        try {
            const auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            return multiLineString.size();

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFLineString *) geometryAtIndex:(NSUInteger)index {
        try {
            const auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            unsigned long size = multiLineString.size();

            if (size == 0 || index > (size -1)) {
                @throw [NSException exceptionWithName: NSRangeException reason: @"Index out of range" userInfo: nil];
            }
            return [[GFLineString alloc] initWithCPPGeometryVariant: multiLineString.at(index)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFLineString *) firstGeometry {
        try {
            const auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            if (multiLineString.size() == 0) {
                return nil;
            }
            return [[GFLineString alloc] initWithCPPGeometryVariant: multiLineString.front()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFLineString *) lastGeometry {
        try {
            const auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            if (multiLineString.size() == 0) {
                return nil;
            }
            return [[GFLineString alloc] initWithCPPGeometryVariant: multiLineString.back()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        const auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

        if (index >= multiLineString.size())
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, multiLineString.size()];

        return [[GFLineString alloc] initWithCPPGeometryVariant: multiLineString[index]];
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *)toGeoJSONGeometry {
        NSMutableArray * lineStrings = [[NSMutableArray alloc] init];

        try {
            auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            for (auto it = multiLineString.begin();  it != multiLineString.end(); ++it ) {
                [lineStrings addObject: gf::GFLineString::geoJSONCoordinatesWithLineString(*it)];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @{@"type": @"MultiLineString", @"coordinates": lineStrings};
    }

#pragma mark - MapKit

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        try {
            auto& multiLineString = boost::polymorphic_strict_get<gf::MultiLineString>(_members->geometryVariant);

            for (auto it = multiLineString.begin();  it != multiLineString.end(); ++it ) {
                [mkPolygons addObject: gf::GFLineString::mkOverlayWithLineString(*it)];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolygons;
    }


@end
