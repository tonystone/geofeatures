/**
*   MultiPolygon.hpp
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
*   Created by Tony Stone on 6/9/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#pragma once

#ifndef __MultiPolygon_HPP_
#define __MultiPolygon_HPP_

#include "Geometry.hpp"
#include "Polygon.hpp"
#include "Collection.hpp"

#include <boost/geometry/core/access.hpp>
#include <boost/geometry/core/coordinate_type.hpp>
#include <boost/geometry/core/coordinate_system.hpp>
#include <boost/geometry/core/coordinate_dimension.hpp>

#include <boost/geometry/geometries/concepts/point_concept.hpp>
#include <vector>

namespace geofeatures {

    /**
    * @class       MultiPolygon
    *
    * @brief       A Collection of Polygons.
    *
    * @author      Tony Stone
    * @date        6/9/15
    */
    class MultiPolygon : public Geometry, public Collection <geofeatures::Polygon> {

    private:
        typedef Collection <geofeatures::Polygon> BaseType;

    public:

        inline MultiPolygon () noexcept : Geometry(), BaseType() {}
        inline MultiPolygon (BaseType & polygons) noexcept : Geometry(), BaseType(polygons) {}

        inline virtual ~MultiPolygon() {};
    };


}   // namespace geofeatures

namespace geofeatures_boost {
    namespace geometry {
        namespace traits
        {
            template<>
            struct tag<geofeatures::MultiPolygon> {
                typedef multi_polygon_tag type;
            };
        }
    } // namespace geometry::traits

    template<>
    struct range_iterator<geofeatures::MultiPolygon>
    { typedef typename geofeatures::MultiPolygon::iterator type; };

    template<>
    struct range_const_iterator<geofeatures::MultiPolygon>
    { typedef typename geofeatures::MultiPolygon::const_iterator type; };

} // namespace boost

#endif //__MultiPolygon_HPP_
