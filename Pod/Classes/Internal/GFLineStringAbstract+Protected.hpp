/**
*   GFLineStringAbstract+Protected.hpp
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

#ifndef __GFLineStringAbstractProtected_hpp
#define __GFLineStringAbstractProtected_hpp

#import <MapKit/MapKit.h>
#import "GFLineStringAbstract.h"

#include "LineString.hpp"

@interface GFLineStringAbstract (Protected)

    - (climate::gf::LineString)cppLineStringWithGeoJSONCoordinates:(NSArray *)coordinates;
    - (NSArray *)geoJSONCoordinatesWithCPPLineString: (const climate::gf::LineString &) linestring;

    - (id <MKOverlay>)mkOverlayWithCPPLineString: (const climate::gf::LineString &) linestring;

@end

#endif // __GFLineStringAbstractProtected_hpp