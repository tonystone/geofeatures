/**
*   GFGeometryCollection+Protected.hpp
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
*   Created by Tony Stone on 9/7/15.
*/
#pragma once

#ifndef __GFGeometryCollectionProtected_hpp
#define __GFGeometryCollectionProtected_hpp

#import <Foundation/Foundation.h>
#import <GeoFeatures/internal/geofeatures/GeometryCollection.hpp>
#import "GFGeometryCollection.h"

// Note: we must specifically include GeometryCollection.hpp here instead of forward declaring GeometryCollection
#include "GeometryCollection.hpp"

@interface GFGeometryCollection (Protected)

    /**
     * Initialize this GFGeometryCollection with an internal GeometryCollection implementation.
     */
    - (instancetype) initWithCPPGeometryCollection: (geofeatures::GeometryCollection<>) aGeometryCollection;

    - (const geofeatures::GeometryCollection<> &) cppConstGeometryCollectionReference;

@end

namespace geofeatures {

    namespace GFGeometryCollection {

        geofeatures::GeometryCollection<> geometryCollectionWithGeoJSONGeometries(NSArray * geometries);

        NSDictionary * geoJSONGeometryWithGeometryCollection(const geofeatures::GeometryCollection<> & geometryCollection);

        NSArray * geoJSONGeometriesWithGeometryCollection(const geofeatures::GeometryCollection <> & geometryCollection);

        id <MKOverlay> mkOverlayWithGeometryCollection(const geofeatures::GeometryCollection<> & geometryCollection);
    }
}

#endif // __GFGeometryCollectionProtected_hpp