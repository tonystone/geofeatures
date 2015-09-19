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

#import "GFPoint+Primitives.hpp"
#import <MapKit/MapKit.h>

#include "internal/geofeatures/Point.hpp"

namespace gf = geofeatures;

gf::Point geofeatures::GFPoint::pointWithGeoJSONCoordinates(NSArray * coordinates) {

    //
    // { "type": "Point",
    //      "coordinates": [100.0, 0.0]
    // }
    //
    try {
        return gf::Point([coordinates[0] doubleValue], [coordinates[1] doubleValue]);

    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
}

NSArray * geofeatures::GFPoint::geoJSONCoordinatesWithPoint(const gf::Point & point) {
    double longitude;
    double latitude;

    try {
        longitude = point.get<0>();
        latitude  = point.get<1>();

    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
    return @[@(longitude),@(latitude)];
}

id <MKOverlay> geofeatures::GFPoint::mkOverlayWithPoint(const gf::Point & point) {
    MKCircle * mkCircle = nil;

    try {
        CLLocationCoordinate2D centerPoint;

        centerPoint.longitude = point.get<0>();
        centerPoint.latitude  = point.get<1>();

        mkCircle = [MKCircle circleWithCenterCoordinate: centerPoint radius: 5.0];

    } catch (std::exception & e) {
        @throw [NSException exceptionWithName:@"Exception" reason: [NSString stringWithUTF8String: e.what()] userInfo:nil];
    }
    return mkCircle;
}