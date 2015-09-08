#import "NSString+CaseInsensitiveHasPrefix.h"

/*
*   GFRing.h
*
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
*   Created by Tony Stone on 08/29/15.
*/

#import "GFRing.h"
#include "GFPoint.h"

#include "GFGeometry+Protected.hpp"
#include "geofeatures/internal/LineString.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>

namespace gf = geofeatures::internal;

@implementation GFRing

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::Ring()];
        return self;
    }

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        try {
            // We only accept a LineString for input but boost wants a polygon wkt so
            // we use the LineString boost impl to parse our LineString wkt and then
            // turn it into a Ring.
            gf::LineString points;

            boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], points);

            gf::Ring ring(points);
            boost::geometry::correct(ring);

            self = [super initWithCPPGeometryVariant: ring];

        } catch (std::exception const & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        id coordinates = jsonDictionary[@"coordinates"];

        if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
            @throw [NSException exceptionWithName: NSInvalidArgumentException reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
        }

        try {
            //
            // Note: GeoJSON does not support a Ring so we
            //       accept a closed LineString
            //
            // For type "LineString", the "coordinates" member must
            // be an array of two or more positions.
            //
            // A LinearRing is closed LineString with 4 or more positions.
            // The first and last positions are equivalent (they represent
            // equivalent points). Though a LinearRing is not explicitly
            // represented as a GeoJSON geometry type, it is referred to
            // in the LineString geometry type definition.
            //
            //  { "type": "LineString",
            //     "coordinates": [ [100.0, 0.0], [101.0, 1.0] ]
            //  }
            //
            gf::Ring ring;

            for (NSArray * coordinate in coordinates) {
                ring.push_back(gf::Point([coordinate[0] doubleValue], [coordinate[1] doubleValue]));
            }
            self =  [super initWithCPPGeometryVariant: ring];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }

        return self;
    }

#pragma mark - Querying a GFLineSting

    - (NSUInteger) count {

        try {
            const auto& ring = boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            return ring.size();

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) geometryAtIndex: (NSUInteger) index {

        try {
            const auto& ring = boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            const auto size = ring.size();

            if (size == 0 || index > (size -1)) {
                @throw [NSException exceptionWithName: NSRangeException reason: @"Index out of range" userInfo: nil];
            }
            return [[GFPoint alloc] initWithCPPGeometryVariant: ring.at(index)];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) firstGeometry {

        try {
            const auto& ring = boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            if (ring.size() == 0) {
                return nil;
            }
            return [[GFPoint alloc] initWithCPPGeometryVariant: ring.front()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (GFPoint *) lastGeometry {

        try {
            const auto& ring = boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            if (ring.size() == 0) {
                return nil;
            }
            return [[GFPoint alloc] initWithCPPGeometryVariant: ring.back()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        const auto& ring = boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

        if (index >= ring.size())
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, ring.size()];

        return [[GFPoint alloc] initWithCPPGeometryVariant: ring[index]];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        try {
            const auto& ring =  boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            NSMutableArray * points = [[NSMutableArray alloc] init];

            for (auto it = ring.begin();  it != ring.end(); ++it ) {
                const double longitude = it->get<0>();
                const double latitude  = it->get<1>();

                [points addObject:@[@(longitude),@(latitude)]];
            }

            // Note: GeoJSON does not support Rings soa lineString is used.
            return @{@"type": @"LineString", @"coordinates": points};

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (NSArray *) mkMapOverlays {

        MKPolyline * mkPolyline = nil;

        try {
            const auto& ring =  boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant);

            size_t pointCount = ring.size();
            CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * pointCount);

            for (std::size_t i = 0; i < pointCount; i++) {
                const gf::Point& point = ring.at(i);

                coordinates[i].longitude = point.get<0>();
                coordinates[i].latitude  = point.get<1>();
            }

            mkPolyline = [MKPolyline polylineWithCoordinates: coordinates count: pointCount];

            free(coordinates);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return @[mkPolyline];
    }

    - (NSString *) toWKTString {
        try {
            std::stringstream stringStream;
            stringStream << boost::geometry::wkt<gf::LineString>(boost::polymorphic_strict_get<gf::Ring>(_members->geometryVariant));

            return [NSString stringWithFormat:@"%s", stringStream.str().c_str()];

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

@end