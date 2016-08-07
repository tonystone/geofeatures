/**
*   MultiPoint.hpp
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

#ifndef __MultiPoint_HPP_
#define __MultiPoint_HPP_

#include "Geometry.hpp"
#include "Point.hpp"
#include "Collection.hpp"

#include <boost/concept/requires.hpp>

#include <boost/geometry/core/tags.hpp>
#include <boost/geometry/geometries/concepts/point_concept.hpp>
#include <vector>

namespace geofeatures {
    
    /**
    * Forward declarations
    */
    class Point;

    /**
    * @class       MultiPoint
    *
    * @brief       A Collection of Points.
    *
    * @author      Tony Stone
    * @date        6/9/15
    */
    class MultiPoint : public Geometry, public Collection <geofeatures::Point> {

    private:
        typedef Collection <geofeatures::Point> BaseType;

    public:
        inline MultiPoint() noexcept : Geometry(), BaseType() {}
        
        template <typename Iterator>
        inline MultiPoint(Iterator begin, Iterator end) : BaseType(begin, end) {}
        
        inline MultiPoint(std::initializer_list<geofeatures::Point> l) : BaseType(l.begin(), l.end()) {}
        inline virtual ~MultiPoint() noexcept {}
    };
    
}   // namespace geofeatures

namespace geofeatures_boost {
    namespace geometry {
        namespace traits
        {
            template<>
            struct tag<geofeatures::MultiPoint> {
                typedef multi_point_tag type;
            };
        }
    } // namespace geometry::traits


} // namespace boost

#endif //__MultiPoint_HPP_
