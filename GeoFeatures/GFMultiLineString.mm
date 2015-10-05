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
#include "GFMultiLineString+Protected.hpp"
#include "GFLineString+Protected.hpp"

#include "internal/geofeatures/MultiLineString.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>
#include <vector>

namespace gf = geofeatures;

@implementation GFMultiLineString {
    @protected
        gf::MultiLineString _multiLineString;
    }

#pragma mark - Construction

    - (instancetype) initWithWKT:(NSString *)wkt {
        NSParameterAssert(wkt != nil);

        if (self = [super init]) {
            try {
                boost::geometry::read_wkt([wkt cStringUsingEncoding: NSUTF8StringEncoding], _multiLineString);

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

            if (!coordinates || ![coordinates isKindOfClass: [NSArray class]]) {
                @throw [NSException exceptionWithName: NSInvalidArgumentException reason: @"Invalid GeoJSON Geometry Object, no coordinates found or coordinates of an invalid type." userInfo: nil];
            }
            _multiLineString = gf::GFMultiLineString::multiLineStringWithGeoJSONCoordinates(coordinates);
        }
        return self;
    }

#pragma mark - NSCopying

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFMultiLineString *) [[GFMultiLineString class] allocWithZone: zone] initWithCPPMultiLineString: _multiLineString];
    }

#pragma mark - NSMutableCopying

    - (id) mutableCopyWithZone: (NSZone *) zone {
        return [(GFMutableMultiLineString *) [[GFMutableMultiLineString class] allocWithZone: zone] initWithCPPMultiLineString: _multiLineString];
    }

#pragma mark - Querying a GFMultiLineString

    - (NSUInteger) count {
        return _multiLineString.size();
    }

    - (GFLineString *) geometryAtIndex:(NSUInteger)index {

        if (index >= _multiLineString.size()) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiLineString.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFLineString alloc] initWithCPPLineString: _multiLineString[index]];
    }

    - (GFLineString *) firstGeometry {

        if (_multiLineString.empty()) {
            return nil;
        }
        return [[GFLineString alloc] initWithCPPLineString: *_multiLineString.begin()];
    }

    - (GFLineString *) lastGeometry {

        if (_multiLineString.empty()) {
            return nil;
        }
        return [[GFLineString alloc] initWithCPPLineString: *(_multiLineString.end() - 1)];
    }

#pragma mark - Indexed Subscripting

    - (GFLineString *) objectAtIndexedSubscript: (NSUInteger) index {

        if (index >= _multiLineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiLineString.size()];
        }
        //
        // Note: We use operator[] below because we've
        //       already checked the bounds above.
        //
        //       Operator[] is also unchecked, will not throw,
        //       and faster than at().
        //
        return [[GFLineString alloc] initWithCPPLineString: _multiLineString[index]];
    }

@end

@implementation GFMultiLineString (Protected)

    - (instancetype) initWithCPPMultiLineString: (gf::MultiLineString) aMultiLineString {

        if (self = [super init]) {
            _multiLineString = aMultiLineString;
        }
        return self;
    }

    - (gf::GeometryVariant) cppGeometryVariant {
        return gf::GeometryVariant(_multiLineString);
    }

    - (gf::GeometryPtrVariant) cppGeometryPtrVariant {
        return gf::GeometryPtrVariant(&_multiLineString);
    }

#pragma mark - GeoJSON Output

    - (NSDictionary *)toGeoJSONGeometry {
        return gf::GFMultiLineString::geoJSONGeometryWithMultiLineString(_multiLineString);
    }

#pragma mark - MapKit

    - (NSArray *)mkMapOverlays {
        NSMutableArray * mkOverlays = [[NSMutableArray alloc] init];

        for (auto it = _multiLineString.begin();  it != _multiLineString.end(); ++it ) {
            [mkOverlays addObject: gf::GFLineString::mkOverlayWithLineString(*it)];
        }
        return mkOverlays;
    }

@end

@implementation GFMutableMultiLineString

    - (void) addGeometry: (GFLineString *) aLineString {
        if (aLineString == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aLineString can not be nil."];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiLineString.push_back([aLineString cppConstLineStringReference]);
    }

    - (void) insertGeometry: (GFLineString *) aLineString atIndex: (NSUInteger) index {
        if (aLineString == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aLineString can not be nil."];
        }
        if (index > _multiLineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiLineString.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        _multiLineString.insert(_multiLineString.begin() + index, [aLineString cppConstLineStringReference]);
    }

    - (void) removeAllGeometries {
        _multiLineString.clear();
    }

    - (void) removeGeometryAtIndex: (NSUInteger) index {
        if (index >= _multiLineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiLineString.size()];
        }
        _multiLineString.erase(_multiLineString.begin() + index);
    }

    - (void) setObject: (GFLineString *) aLineString atIndexedSubscript: (NSUInteger) index {

        if (aLineString == nil) {
            [NSException raise: NSInvalidArgumentException format: @"aLineString can not be nil."];
        }
        if (index > _multiLineString.size()) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, (unsigned long) _multiLineString.size()];
        }
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        if (index == _multiLineString.size()) {
            _multiLineString.push_back([aLineString cppConstLineStringReference]);
        } else {
            _multiLineString[index] = [aLineString cppConstLineStringReference];
        }
    }

@end

#pragma mark - Primitives

geofeatures::MultiLineString geofeatures::GFMultiLineString::multiLineStringWithGeoJSONCoordinates(NSArray * coordinates) {
    gf::MultiLineString multiLineString;

    for (NSArray * coordinate in coordinates) {
        // Note: geofeatures::<collection type> classes will throw an "Objective-C"
        // NSMallocException if they fail to allocate memory for the operation below
        // so no C++ exception block is required.
        multiLineString.push_back(gf::GFLineString::lineStringWithGeoJSONCoordinates(coordinate));
    }
    return multiLineString;
}

NSDictionary * geofeatures::GFMultiLineString::geoJSONGeometryWithMultiLineString(const geofeatures::MultiLineString & multiLineString) {
    return @{@"type": @"MultiLineString", @"coordinates": geoJSONCoordinatesWithMultiLineString(multiLineString)};
}

NSArray * geofeatures::GFMultiLineString::geoJSONCoordinatesWithMultiLineString(const geofeatures::MultiLineString & multiLineString) {
    NSMutableArray * lineStrings = [[NSMutableArray alloc] init];

    for (auto it = multiLineString.begin();  it != multiLineString.end(); ++it ) {
        [lineStrings addObject: gf::GFLineString::geoJSONCoordinatesWithLineString(*it)];
    }
    return lineStrings;

}
