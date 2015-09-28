/**
*   Ring.hpp
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

#ifndef __Ring_HPP_
#define __Ring_HPP_

#include "Geometry.hpp"
#include "Point.hpp"
#include "Collection.hpp"

#include <boost/geometry/core/closure.hpp>
#include <boost/geometry/core/point_order.hpp>
#include <boost/geometry/core/tag.hpp>
#include <boost/geometry/core/tags.hpp>

#include <boost/geometry/geometries/concepts/point_concept.hpp>
#include <vector>

namespace geofeatures {

    /**
     * @class       Ring
     *
     * @brief       A Ring of Points.
     *
     * @author      Tony Stone
     * @date        6/9/15
     */
    class Ring : public Geometry, public Collection <geofeatures::Point> {

    private:
        typedef Collection <geofeatures::Point> BaseType;

    public:
        inline Ring() noexcept : Geometry(), BaseType() {}
        inline Ring(Ring & other) noexcept : Geometry(), BaseType(other) {}
        inline Ring(Ring const & other) noexcept : Geometry(), BaseType(other) {}
        inline Ring(BaseType & other) noexcept : Geometry(), BaseType(other) {}
        inline Ring(BaseType const & other) noexcept : Geometry(), BaseType(other) {}
        
        inline virtual ~Ring() noexcept {};
    };
    
}   // namespace geofeatures

namespace geofeatures_boost {
    namespace geometry {
        namespace traits
        {
            template<>
            struct tag<geofeatures::Ring> {
                typedef ring_tag type;
            };

            template<>
            struct point_order<geofeatures::Ring> {
                static const order_selector value = clockwise;
            };

            template<>
            struct closure<geofeatures::Ring> {
                static const closure_selector value = closed;
            };
        }
    } // namespace geometry::traits

    template<>
    struct range_iterator<geofeatures::Ring>
    { typedef typename geofeatures::Ring::iterator type; };

    template<>
    struct range_const_iterator<geofeatures::Ring>
    { typedef typename geofeatures::Ring::const_iterator type; };

} // namespace boost

#endif //__Ring_HPP_












