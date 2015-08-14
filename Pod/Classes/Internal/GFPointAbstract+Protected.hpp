/**
*   GFPointAbstract+Protected.hpp
*
*   Copyright 2015 The Climate Corporation
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
*   Created by Tony Stone on 6/3/15.
*/

#ifndef __GFPointAbstractProtected_hpp
#define __GFPointAbstractProtected_hpp

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GFPointAbstract.h"

#include "Point.hpp"
#include <boost/geometry.hpp>

@interface GFPointAbstract (Protected)

    - (climate::gf::Point)cppPointWithGeoJSONCoordinates: (NSArray *) coordinates;
    - (NSArray *)geoJSONCoordinatesWithCPPPoint: (const climate::gf::Point &) point;

    - (id <MKOverlay>)mkOverlayWithCPPPoint: (const climate::gf::Point &) point;

@end

#endif // __GFPointAbstractProtected_hpp