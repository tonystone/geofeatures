/**
*   GeometryCollection.hpp
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
*   Created by Tony Stone on 6/10/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#pragma once

#ifndef __GeometryCollection_HPP_
#define __GeometryCollection_HPP_

#include "Geometry.hpp"
#include "Point.hpp"
#include "MultiPoint.hpp"
#include "Box.hpp"
#include "LineString.hpp"
#include "MultiLineString.hpp"
#include "Ring.hpp"
#include "Polygon.hpp"
#include "MultiPolygon.hpp"

#include "Collection.hpp"
#include "Allocator.hpp"

#include <boost/variant.hpp>
#include <vector>

namespace geofeatures {

    template <typename T, typename Allocator>
    class GeometryCollection;
    
    /**
    * @class       GeometryCollection
    *
    * @brief       A Collection of Geometries.
    *
    * @author      Tony Stone
    * @date        6/9/15
     *
    */
    template <typename T = boost::make_recursive_variant<
            geofeatures::Point,
            geofeatures::MultiPoint,
            geofeatures::Box,
            geofeatures::LineString,
            geofeatures::MultiLineString,
            geofeatures::Ring,
            geofeatures::Polygon,
            geofeatures::MultiPolygon,
            GeometryCollection<boost::recursive_variant_,geofeatures::Allocator<boost::recursive_variant_>>>::type, typename Allocator = geofeatures::Allocator<T>>
    class GeometryCollection : public Geometry, public Collection <T, Allocator> {

    private:
        typedef Collection <T, Allocator> BaseType;


    public:
        inline GeometryCollection() noexcept : Geometry(), BaseType() {}
        inline GeometryCollection(const GeometryCollection & other) noexcept : Geometry(), BaseType(other) {}
        inline virtual ~GeometryCollection() noexcept {}
    };

}   // namespace geofeatures

#endif //__GeometryCollection_HPP_
