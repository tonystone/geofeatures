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
#include "GFLineString+Primitives.hpp"

#include "internal/geofeatures/MultiLineString.hpp"
#include "internal/geofeatures/GeometryVariant.hpp"

#include <boost/geometry/io/wkt/wkt.hpp>
#include <vector>

namespace gf = geofeatures;

@implementation GFMultiLineString {
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
            for (NSArray * lineString in coordinates) {
                _multiLineString.push_back(gf::GFLineString::lineStringWithGeoJSONCoordinates(lineString));
            }
        }
        return self;
    }

    - (id) copyWithZone:(struct _NSZone *)zone {
        return [(GFMultiLineString *) [[self class] allocWithZone: zone] initWithCPPMultiLineString: _multiLineString];
    }

#pragma mark - Querying a GFMultiLineString

    - (NSUInteger) count {
        return _multiLineString.size();
    }

    - (GFLineString *) geometryAtIndex:(NSUInteger)index {

        auto size = _multiLineString.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiLineString.size()];
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

        if (_multiLineString.size() == 0) {
            return nil;
        }
        return [[GFLineString alloc] initWithCPPLineString: _multiLineString.front()];
    }

    - (GFLineString *) lastGeometry {

        if (_multiLineString.size() == 0) {
            return nil;
        }
        return [[GFLineString alloc] initWithCPPLineString: _multiLineString.back()];
    }

#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        auto size = _multiLineString.size();

        if (size == 0 || index > (size -1)) {
            [NSException raise: NSRangeException format: @"Index %li is beyond bounds [0, %li].", (unsigned long) index, _multiLineString.size()];
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
        NSMutableArray * lineStrings = [[NSMutableArray alloc] init];

        for (auto it = _multiLineString.begin();  it != _multiLineString.end(); ++it ) {
            [lineStrings addObject: gf::GFLineString::geoJSONCoordinatesWithLineString(*it)];
        }
        return @{@"type": @"MultiLineString", @"coordinates": lineStrings};
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
