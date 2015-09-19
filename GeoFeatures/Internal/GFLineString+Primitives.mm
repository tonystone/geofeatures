/**
*   GFLineString+Protected.hpp
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
*   Created by Tony Stone on 9/3/15.
*/

#import "GFLineString+Primitives.hpp"

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/correct.hpp>

#include "internal/geofeatures/LineString.hpp"

namespace gf = geofeatures;

//
// Protected free functions
//
gf::LineString geofeatures::GFLineString::lineStringWithGeoJSONCoordinates(NSArray * coordinates) {

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

NSArray * geofeatures::GFLineString::geoJSONCoordinatesWithLineString(const gf::LineString & linestring) {

    NSMutableArray * points = [[NSMutableArray alloc] init];

    try {
        for (auto it = linestring.begin();  it != linestring.end(); ++it) {
            const double longitude = it->get<0>();
            const double latitude  = it->get<1>();

            [points addObject:@[@(longitude),@(latitude)]];
        }
    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
    return points;
}

id <MKOverlay> geofeatures::GFLineString::mkOverlayWithLineString(const gf::LineString & linestring) {

    MKPolyline * mkPolyline = nil;

    try {
        size_t pointCount = linestring.size();
        CLLocationCoordinate2D * coordinates = (CLLocationCoordinate2D *) malloc(sizeof(CLLocationCoordinate2D) * pointCount);

        for (std::size_t i = 0; i < pointCount; i++) {
            const auto& point = linestring.at(i);

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
