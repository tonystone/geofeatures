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
#include "GFRing+Protected.hpp"
#include "GFPoint+Protected.hpp"
#include "GFLineString+Protected.hpp"

#include "internal/geofeatures/Ring.hpp"
#include "internal/geofeatures/LineString.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>

namespace gf = geofeatures;

@implementation GFRing {
    @protected
        gf::Ring _ring;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                // We only accept a LineString for input but boost wants a polygon wkt so
                // we use the LineString boost impl to parse our LineString wkt and then
                // turn it into a Ring.
                gf::LineString points;

                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], points);

                _ring = gf::Ring(points);
                boost::geometry::correct(_ring);

            } catch (std::exception const & e) {
                @throw [NSException exceptionWithName: @"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo: nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {
            id coordinates = jsonDictionary[@"coordinates"];

            if (!coordinates || ![coordinates isKindOfClass: [NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo: nil];
            }
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
            _ring = gf::GFRing::ringWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFRing *) [[GFRing class] allocWithZone: zone] initWithCPPRing: _ring];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableRing *) [[GFMutableRing class] allocWithZone: zone] initWithCPPRing: _ring];
    }
#pragma mark - Querying a GFLineSting

    - (NSUInteger) count {
        return _ring.size();
    }

    - (GFPoint *) pointAtIndex: (NSUInteger) index {

        if (index >= _ring.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _ring.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _ring[index]];
    }

    - (GFPoint *) firstPoint {

        if (_ring.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *_ring.begin()];
    }

    - (GFPoint *) lastPoint {

        if (_ring.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *(_ring.end() - 1)];
    }

#pragma mark - Indexed Subscripting

    - (GFPoint *) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _ring.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _ring.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _ring[index]];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFRing::geoJSONGeometryWithRing(_ring);
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFRing::mkOverlayWithRing(_ring)];
    }

@end

@implementation GFRing (Protected)

    - (instancetype) initWithCPPRing: (gf::Ring) aRing {

        if (self = [super init]) {
            _ring = aRing;
        }
        return self;
    }

    - (const gf::Ring &) cppConstRingReference {
        return _ring;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_ring);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_ring);
    }

@end

@implementation GFMutableRing

    - (void) addPoint: (GFPoint *) aPoint {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _ring.push_back(gf::Point([aPoint x], [aPoint y]));
    }

    - (void) insertPoint: (GFPoint *) aPoint atIndex: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _ring.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _ring.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _ring.insert(_ring.begin() + index, gf::Point([aPoint x], [aPoint y]));
    }

    - (void) removeAllPoints {
        _ring.clear();
    }

    - (void) removePointAtIndex: (NSUInteger) index {

        if (index >= _ring.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _ring.size()];
        }
        _ring.erase(_ring.begin() + index);
    }

    - (void) setObject: (GFPoint *) aPoint atIndexedSubscript: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _ring.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _ring.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _ring.size()) {
            _ring.push_back([aPoint cppConstPointReference]);
        } else {
            _ring[index] = [aPoint cppConstPointReference];
        }
    }

@end

#pragma mark - Primitives

//
// Protected free functions
//
gf::Ring geofeatures::GFRing::ringWithGeoJSONCoordinates(NSArray * coordinates) {
    gf::Ring ring;

    for (NSArray * coordinate in coordinates) {
        ring.push_back(gf::Point([coordinate[0] doubleValue], [coordinate[1] doubleValue]));
    }
    // Make sure this ring is correct.
    boost::geometry::correct(ring);

    return ring;
}

NSDictionary * geofeatures::GFRing::geoJSONGeometryWithRing(const geofeatures::Ring & ring) {
    return @{@"type": @"LineString", @"coordinates": gf::GFRing::geoJSONCoordinatesWithRing(ring)};
}

NSArray * geofeatures::GFRing::geoJSONCoordinatesWithRing(const gf::Ring & ring) {

    NSMutableArray * points = [[NSMutableArray alloc] init];

    for (auto it = ring.begin();  it != ring.end(); ++it) {
        const double longitude = it->get<0>();
        const double latitude  = it->get<1>();

        [points addObject:@[@(longitude),@(latitude)]];
    }
    return points;
}

id <MKOverlay> geofeatures::GFRing::mkOverlayWithRing(const gf::Ring & ring) {

    size_t pointCount = ring.size();
    CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * pointCount);

    for (std::size_t i = 0; i < pointCount; i++) {
        const auto& point = ring[i];

        coordinates[i].longitude = point.get<0>();
        coordinates[i].latitude  = point.get<1>();
    }

    MKPolygon * mkPolygon = [MKPolygon polygonWithCoordinates: coordinates count: pointCount];

    free(coordinates);

    return mkPolygon;
}