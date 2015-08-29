/*
*   GFLineStringAbstract.mm
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
*   Created by Tony Stone on 6/6/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import "GFLineStringAbstract+Protected.hpp"
#import <MapKit/MapKit.h>

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>
#include <boost/geometry/algorithms/is_valid.hpp>

#include "geofeatures/internal/LineString.hpp"

@implementation GFLineStringAbstract
@end

namespace gf = geofeatures::internal;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation GFLineStringAbstract (Protected)

    - (id) init {
        NSAssert(![[self class] isMemberOfClass: [GFLineStringAbstract class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));
        return nil;
    }

#pragma clang diagnostic pop

    - (gf::LineString)cppLineStringWithGeoJSONCoordinates:(NSArray *)coordinates {

        try {
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

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
    }

    - (NSArray *)geoJSONCoordinatesWithCPPLineString: (const gf::LineString &) linestring  {

        NSMutableArray * points = [[NSMutableArray alloc] init];

        try {
            for (gf::LineString::vector::const_iterator it = linestring.begin();  it != linestring.end(); ++it ) {
                const double longitude = it->get<0>();
                const double latitude  = it->get<1>();

                [points addObject:@[@(longitude),@(latitude)]];
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return points;
    }

    - (id <MKOverlay>)mkOverlayWithCPPLineString: (const gf::LineString &) linestring {

        MKPolyline * mkPolyline = nil;

        try {
            size_t pointCount = linestring.size();
            CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * pointCount);

            for (gf::LineString::vector::size_type i = 0; i < pointCount; i++) {
                const gf::Point& point = linestring.at(i);

                coordinates[i].longitude = point.get<0>();
                coordinates[i].latitude  = point.get<1>();
            }

            mkPolyline = [MKPolyline polylineWithCoordinates: coordinates count: pointCount];

            free(coordinates);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
        }
        return mkPolyline;
    }

@end