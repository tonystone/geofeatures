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

namespace  gf = geofeatures::internal;

namespace geofeatures {
    namespace internal {

        class AddGeometry : public  boost::static_visitor<void> {

        public:
            inline AddGeometry(gf::GeometryCollection & geometryCollection) : geometryCollection(geometryCollection) {}

            template <typename T>
            void operator()(const T & v) const {
                geometryCollection.push_back(v);
            }

            void operator()(const gf::GeometryCollection & v)  const {
                ;   // Do nothing
            }

        private:
            gf::GeometryCollection & geometryCollection;
        };
    }
}

@implementation GFGeometryCollection

#pragma mark - Public methods

    - (instancetype) init {
        self = [super initWithCPPGeometryVariant: gf::GeometryCollection()];
        return self;
    }

    - (instancetype)initWithArray:(NSArray *)array {
        NSParameterAssert(array != nil);

        self = [super initWithCPPGeometryVariant: [self cppGeometryCollectionWithArray: array]];

        return self;
    }

    - (gf::GeometryCollection) cppGeometryCollectionWithArray: (NSArray *) array {
        NSParameterAssert(array != nil);

        try {
            gf::GeometryCollection geometryCollection;

            for (GFGeometry * geometry in array) {

                if (![geometry isKindOfClass: [GFGeometry class]]) {
                    @throw [NSException exceptionWithName: NSInvalidArgumentException reason:[NSString stringWithFormat: @"Invalid class in array for initialization of %@.  All array elements must be a GFGeometry or subclass of GFGeometry.", NSStringFromClass([self class])] userInfo: nil];
                }
                boost::apply_visitor(gf::AddGeometry(geometryCollection), geometry->_members->geometryVariant);
            }
            return geometryCollection;

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }

    - (GFGeometry *)geometryAtIndex:(NSUInteger)index {

        try {
            auto& geometry = boost::polymorphic_strict_get<gf::GeometryCollection>(_members->geometryVariant);

            if (index >= geometry.size()) {
                @throw [NSException exceptionWithName: NSRangeException reason: @"Index out of range." userInfo: nil];
               
            } else {
                 return boost::apply_visitor(gf::GFInstanceFromVariant(), geometry.at(index));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }

    - (GFGeometry *)firstGeometry {
        try {
            auto& geometry = boost::polymorphic_strict_get<gf::GeometryCollection>(_members->geometryVariant);

            if (geometry.size() > 0) {

                return boost::apply_visitor(gf::GFInstanceFromVariant(), *(geometry.begin()));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }

    - (GFGeometry *)lastGeometry {

        try {
            auto& geometry = boost::polymorphic_strict_get<gf::GeometryCollection>(_members->geometryVariant);

            if (geometry.size() > 0) {

                return boost::apply_visitor(gf::GFInstanceFromVariant(), *(geometry.end()));
            }
        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        return nil;
    }


    - (NSUInteger)count {

        try {
            auto& geometry = boost::polymorphic_strict_get<gf::GeometryCollection>(_members->geometryVariant);

            return geometry.size();

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
    }


#pragma mark - Protected methods

    - (instancetype)initWithWKT:(NSString *) wktString {

        NSParameterAssert(wktString != nil);
        
        if ((self = [super initWithCPPGeometryVariant: [self parseWKT: wktString]])) {}
        return self;
    }

    - (gf::GeometryCollection) parseWKT: (NSString *) wkt {
        gf::GeometryCollection geometryCollection;
        
        try {
            gf::readWKT([wkt cStringUsingEncoding:NSUTF8StringEncoding], geometryCollection);

        } catch (std::exception & e) {
            @throw [NSException exceptionWithName:@"Exception" reason:[NSString stringWithUTF8String:e.what()] userInfo:nil];
        }
        
        return geometryCollection;
    }

    - (NSDictionary *)toGeoJSONGeometry {
        return [super toGeoJSONGeometry];
    }


#pragma mark - Indexed Subscripting

    - (id) objectAtIndexedSubscript: (NSUInteger) index {

        auto& geometryCollection = boost::polymorphic_strict_get<gf::GeometryCollection>(_members->geometryVariant);;

        if (index >= geometryCollection.size())
            [NSException raise:NSRangeException format:@"Index %li is beyond bounds [0, %li].", (unsigned long) index, geometryCollection.size()];

        return boost::apply_visitor(gf::GFInstanceFromVariant(), geometryCollection[index]);
    }

@end
