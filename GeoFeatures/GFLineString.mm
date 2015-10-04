/*
*   GFLineString.mm
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

#include "GFLineString+Protected.hpp"
#include "GFPoint+Protected.hpp"

#include "internal/geofeatures/Point.hpp"
#include "internal/geofeatures/LineString.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>
#include <boost/geometry/io/wkt/wkt.hpp>

namespace gf = geofeatures;

@implementation GFLineString {
    @protected
        gf::LineString _lineString;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _lineString);
                
            } catch (std::exception & e) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
            }
        }
        return self;
    }

    - (instancetype) initWithGeoJSONGeometry:(NSDictionary *)jsonDictionary {
        NSParameterAssert(jsonDictionary != nil);

        if (self = [super init]) {
            id coordinates = jsonDictionary[@"coordinates"];
            
            if (!coordinates || ![coordinates isKindOfClass:[NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason:@"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo:nil];
            }
            
            _lineString = gf::GFLineString::lineStringWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFLineString *) [[GFLineString class] allocWithZone: zone] initWithCPPLineString: _lineString];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableLineString *) [[GFMutableLineString class] allocWithZone: zone] initWithCPPLineString: _lineString];
    }

#pragma mark - Querying a GFLineSting

    - (NSUInteger) count {
        return _lineString.size();
    }

    - (GFPoint *) pointAtIndex: (NSUInteger) index {

        if (index >= _lineString.size()) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _lineString.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _lineString[index]];
    }

    - (GFPoint *) firstPoint {

        if (_lineString.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *_lineString.begin()];
    }

    - (GFPoint *) lastPoint {

        if (_lineString.empty()) {
            return nil;
        }
        return [[GFPoint alloc] initWithCPPPoint: *(_lineString.end() - 1)];
    }

#pragma mark - Indexed Subscripting

    - (GFPoint *) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _lineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _lineString.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFPoint alloc] initWithCPPPoint: _lineString[index]];
    }

    - (NSDictionary *) toGeoJSONGeometry {
        return gf::GFLineString::geoJSONGeometryWithLineString(_lineString);
    }

    - (NSArray *) mkMapOverlays {
        return @[gf::GFLineString::mkOverlayWithLineString(_lineString)];
    }

@end

@implementation GFLineString (Protected)

    - (instancetype) initWithCPPLineString: (gf::LineString) aLineString {

        if (self = [super init]) {
            _lineString = aLineString;
        }
        return self;
    }

    - (const gf::LineString &) cppConstLineStringReference {
        return _lineString;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_lineString);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_lineString);
    }

@end

@implementation GFMutableLineString

    - (void) addPoint: (GFPoint *) aPoint {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _lineString.push_back(gf::Point([aPoint x], [aPoint y]));
    }

    - (void) insertPoint: (GFPoint *) aPoint atIndex: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _lineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _lineString.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _lineString.insert(_lineString.begin() + index, gf::Point([aPoint x], [aPoint y]));
    }

    - (void) removeAllPoints {
        _lineString.clear();
    }

    - (void) removePointAtIndex: (NSUInteger) index {

        if (index >= _lineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _lineString.size()];
        }
        _lineString.erase(_lineString.begin() + index);
    }

    - (void) setObject: (GFPoint *) aPoint atIndexedSubscript: (NSUInteger) index {

        if (aPoint == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aPoint can not be nil."];
        }
        if (index > _lineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _lineString.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _lineString.size()) {
            _lineString.push_back([aPoint cppConstPointReference]);
        } else {
            _lineString[index] = [aPoint cppConstPointReference];
        }
    }

@end

#pragma mark - Primitives

//
// Protected free functions
//
gf::LineString geofeatures::GFLineString::lineStringWithGeoJSONCoordinates(NSArray * coordinates) {
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
    gf::LineString linestring = {};

    for (NSArray * coordinate in coordinates) {
        linestring.push_back(gf::Point([coordinate[0] doubleValue], [coordinate[1] doubleValue]));
    }
    // Make sure this linestring is correct.
    boost::geometry::correct(linestring);

    return linestring;
}

NSDictionary * geofeatures::GFLineString::geoJSONGeometryWithLineString(const geofeatures::LineString & lineString) {
    return @{@"type": @"LineString", @"coordinates": gf::GFLineString::geoJSONCoordinatesWithLineString(lineString)};
}

NSArray * geofeatures::GFLineString::geoJSONCoordinatesWithLineString(const gf::LineString & lineString) {

    NSMutableArray * points = [[NSMutableArray alloc] init];

    for (auto it = lineString.begin();  it != lineString.end(); ++it) {
        const double longitude = it->get<0>();
        const double latitude  = it->get<1>();

        [points addObject:@[@(longitude),@(latitude)]];
    }
    return points;
}

id <MKOverlay> geofeatures::GFLineString::mkOverlayWithLineString(const gf::LineString & lineString) {


    size_t pointCount = lineString.size();
    CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * pointCount);

    for (std::size_t i = 0; i < pointCount; i++) {
        const auto& point = lineString[i];

        coordinates[i].longitude = point.get<0>();
        coordinates[i].latitude  = point.get<1>();
    }

    MKPolyline * mkPolyline = [MKPolyline polylineWithCoordinates: coordinates count: pointCount];

    free(coordinates);

    return mkPolyline;
}

