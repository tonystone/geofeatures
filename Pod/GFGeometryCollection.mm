/*
*   GFGeometryCollection.mm
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
*   Created by Tony Stone on 6/5/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#import <Foundation/Foundation.h>
#import "GFGeometryCollection.h"

#include "GFGeometry+Protected.hpp"
#include "GFGeometry.h"
#include "GFPoint.h"
#include "GFMultiPoint.h"
#include "GFBox.h"
#include "GFLineString.h"
#include "GFMultiLineString.h"
#include "GFPolygon.h"
#include "GFMultiPolygon.h"

#include "geofeatures/internal/GeometryVariant.hpp"
#include "geofeatures/internal/GeometryCollection.hpp"

#include "ReadWKT.hpp"

using namespace geofeatures::internal;

namespace geofeatures {
    namespace internal {
        namespace detail {

            class GFGeometryInstanceFromVariant : public  boost::static_visitor<GFGeometry *> {
            public:
                template <typename T>
                GFGeometry * operator()(const T & v) const {
                    return nil;
                }
                GFGeometry * operator()(const geofeatures::internal::Point & v) const {
                    return [[GFPoint alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::MultiPoint & v) const {
                    return [[GFMultiPoint alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::Box & v) const {
                    return [[GFBox alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::LineString & v) const {
                    return [[GFLineString alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::MultiLineString & v) const {
                    return [[GFMultiLineString alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::Polygon & v) const {
                    return [[GFPolygon alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::MultiPolygon & v) const {
                    return [[GFMultiPolygon alloc] initWithCPPGeometryVariant: v];;
                }
                GFGeometry * operator()(const geofeatures::internal::GeometryCollection & v) const {
                    return [[GFGeometryCollection alloc] initWithCPPGeometryVariant: v];;
                }
            };

            class AddGeometry : public  boost::static_visitor<void> {
                
            public:
                inline AddGeometry(GeometryCollection & geometryCollection) : geometryCollection(geometryCollection) {}
                
                template <typename T>
                void operator()(const T & v) const {
                    geometryCollection.push_back(v);
                }
     
                void operator()(const GeometryCollection & v)  const {
                    ;   // Do nothing
                }

            private:
                GeometryCollection & geometryCollection;
            };
        }
    }
}

using namespace geofeatures::internal::detail;

@implementation GFGeometryCollection

#pragma mark - Public methods

    - (instancetype)init {

        self = [super initWithCPPGeometryVariant: geofeatures::internal::GeometryCollection()];

        return self;
    }

    - (instancetype)initWithArray:(NSArray *)array {
        NSParameterAssert(array != nil);

        self = [super initWithCPPGeometryVariant: [self cppGeometryCollectionWithArray: array]];

        return self;
    }

    - (GeometryCollection) cppGeometryCollectionWithArray: (NSArray *) array {
        NSParameterAssert(array != nil);

        try {
            GeometryCollection geometryCollection;

            for (GFGeometry * geometry in array) {

                if (![geometry isKindOfClass: [GFGeometry class]]) {
                    @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithFormat: @"Invalid class in array for initialization of %@.  All array elements must be a GFGeometry or subclass of GFGeometry.", NSStringFromClass([self class])] userInfo: nil];
                }
                boost::apply_visitor(AddGeometry(geometryCollection), [geometry cppGeometryReference]);
            }
            return geometryCollection;

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *)geometryAtIndex:(NSUInteger)index {

        try {
            const GeometryCollection & geometry = boost::polymorphic_strict_get<GeometryCollection>([self cppGeometryConstReference]);

            if (index >= geometry.size()) {
                @throw [NSException exceptionWithName: NSRangeException reason: @"Index out of range." userInfo: nil];
               
            } else {
                 return boost::apply_visitor(GFGeometryInstanceFromVariant(), geometry.at(index));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }

    - (GFGeometry *)firstGeometry {
        try {
            const GeometryCollection & geometry = boost::polymorphic_strict_get<GeometryCollection>([self cppGeometryConstReference]);

            if (geometry.size() > 0) {

                return boost::apply_visitor(GFGeometryInstanceFromVariant(), *(geometry.begin()));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }

    - (GFGeometry *)lastGeometry {

        try {
            const GeometryCollection & geometry = boost::polymorphic_strict_get<GeometryCollection>([self cppGeometryConstReference]);

            if (geometry.size() > 0) {

                return boost::apply_visitor(geofeatures::internal::detail::GFGeometryInstanceFromVariant(), *(geometry.end()));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }


    - (NSUInteger)count {

        try {
            const GeometryCollection & geometry = boost::polymorphic_strict_get<GeometryCollection>([self cppGeometryConstReference]);

            return geometry.size();

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }


#pragma mark - Protected methods

    - (id)initWithWKT:(NSString *) wktString {

        NSParameterAssert(wktString != nil);
        
        if ((self = [super initWithCPPGeometryVariant: [self parseWKT: wktString]])) {}
        return self;
    }

    - (geofeatures::internal::GeometryCollection) parseWKT: (NSString *) wkt {
        geofeatures::internal::GeometryCollection geometryCollection;
        
        try {
            geofeatures::internal::readWKT([wkt cStringUsingEncoding:NSUTF8StringEncoding], geometryCollection);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        
        return geometryCollection;
    }

    - (NSDictionary *)toGeoJSONGeometry {
        return [super toGeoJSONGeometry];
    }


@end