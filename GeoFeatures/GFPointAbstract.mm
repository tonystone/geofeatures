/*
*   GFPointAbstract.mm
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

#import "GFPointAbstract+Protected.hpp"
#import <MapKit/MapKit.h>

@implementation GFPointAbstract
@end

namespace gf = geofeatures::internal;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation GFPointAbstract (Protected)

    - (id) init {
        NSAssert(![[self class] isMemberOfClass: [GFPointAbstract class]], @"Abstract class %@ can not be instantiated.  Please use one of the subclasses instead.", NSStringFromClass([self class]));
        return nil;
    }

#pragma clang diagnostic pop

    - (gf::Point)cppPointWithGeoJSONCoordinates:(NSArray *)coordinates {

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

    - (NSArray *)geoJSONCoordinatesWithCPPPoint: (const gf::Point &) point {
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

    - (id <MKOverlay>)mkOverlayWithCPPPoint: (const gf::Point &) point {
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

@end