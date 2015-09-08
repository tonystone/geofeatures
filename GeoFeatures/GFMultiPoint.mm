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

#include "GFGeometry+Protected.hpp"
#include "GFPoint+Primitives.hpp"

#include "geofeatures/internal/MultiPoint.hpp"
#include "geofeatures/internal/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures::internal;

@implementation GFMultiPoint

#pragma mark - Construction

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::MultiPoint()];
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            gf::MultiPoint multiPoint;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], multiPoint);

            self = [super initWithCPPGeometryVariant: multiPoint];

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
        // Note: Coordinates of a MultiPoint are an array of positions
        //
        // { "type": "MultiPoint",
        //      "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
        // }
        //
        gf::MultiPoint multiPoint;

        try {
            for (NSArray * coordinate in coordinates) {
                multiPoint.push_back(gf::GFPoint::pointWithGeoJSONCoordinates(coordinate));
            }

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }

        self = [super initWithCPPGeometryVariant: multiPoint];
        return self;
    }

#pragma mark - Querying a GFMultiPoint

    - (NSUInteger)count {

        try {
            const auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            return multiPoint.size();

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) geometryAtIndex: (NSUInteger) index {

        try {
            auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            unsigned long size = multiPoint.size();

            if (size == 0 || index > (size -1)) {
                @throw [NSException exceptionWithName: NSRangeException reason: @"Index out of range" userInfo: nil];
            }

            return [[GFPoint alloc] initWithCPPGeometryVariant: multiPoint.at(index)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) firstGeometry {

        try {
            const auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            if (multiPoint.size() == 0) {
                return nil;
            }

            return [[GFPoint alloc] initWithCPPGeometryVariant: multiPoint.front()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) lastGeometry {

        try {
            auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            if (multiPoint.size() == 0) {
                return nil;
            }

            return [[GFPoint alloc] initWithCPPGeometryVariant: multiPoint.back()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        const auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

        if (index >= multiPoint.size())
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, multiPoint.size()];

        return [[GFPoint alloc] initWithCPPGeometryVariant: multiPoint[index]];
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *)toGeoJSONGeometry {
        NSMutableArray * points = [[NSMutableArray alloc] init];

        try {
            auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            for (auto it = multiPoint.begin();  it != multiPoint.end(); ++it ) {
                [points addObject: gf::GFPoint::geoJSONCoordinatesWithPoint(*it)];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @{@"type": @"MultiPoint", @"coordinates": points};
    }

#pragma mark - MapKit

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkPolygons = [[NSMutableArray alloc] init];

        try {

            auto& multiPoint = boost::polymorphic_strict_get<gf::MultiPoint>(_members->geometryVariant);

            for (auto it = multiPoint.vector::begin();  it != multiPoint.vector::end(); ++it ) {
                [mkPolygons addObject: gf::GFPoint::mkOverlayWithPoint(*it)];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolygons;
    }

@end
