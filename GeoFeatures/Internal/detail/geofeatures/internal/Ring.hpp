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

#ifndef __Ring_HPP_
#define __Ring_HPP_

#include "Geometry.hpp"
#include "Point.hpp"

#include <boost/geometry/core/closure.hpp>
#include <boost/geometry/core/point_order.hpp>
#include <boost/geometry/core/tag.hpp>
#include <boost/geometry/core/tags.hpp>

#include <boost/geometry/geometries/concepts/point_concept.hpp>
#include <vector>

namespace geofeatures {
    namespace internal {
        
        /**
        * Base type for Ring class
        */
        typedef std::vector<geofeatures::internal::Point> RingBaseType;

        /**
         * @class       Ring
         *
         * @brief       A Ring of Points.
         *
         * @author      Tony Stone
         * @date        6/9/15
         */
        class Ring : public Geometry, public RingBaseType {

        public:
            inline Ring() : Geometry(), RingBaseType() {}
            inline Ring(Ring & other) : Geometry(), RingBaseType(other) {}
            inline Ring(Ring const & other) : Geometry(), RingBaseType(other) {}
            
            inline virtual ~Ring() {};
        };

        /** @defgroup BoostRangeIterators
        *
        * @{
        */
        inline geofeatures::internal::RingBaseType::iterator range_begin(Ring& r) {return r.begin();}
        inline geofeatures::internal::RingBaseType::iterator range_end(Ring& r) {return r.end();}
        inline geofeatures::internal::RingBaseType::const_iterator range_begin(const Ring& r) {return r.begin();}
        inline geofeatures::internal::RingBaseType::const_iterator range_end(const Ring& r) {return r.end();}
        /** @} */

    }   // namespace internal
}   // namespace geofeatures

namespace geofeatures_boost {
    namespace geometry {
        namespace traits
        {
            template<>
            struct tag<geofeatures::internal::Ring> {
                typedef ring_tag type;
            };

            template<>
            struct point_order<geofeatures::internal::Ring> {
                static const order_selector value = clockwise;
            };

            template<>
            struct closure<geofeatures::internal::Ring> {
                static const closure_selector value = closed;
            };
        }
    } // namespace geometry::traits

    template<>
    struct range_iterator<geofeatures::internal::Ring>
    { typedef geofeatures::internal::RingBaseType::iterator type; };

    template<>
    struct range_const_iterator<geofeatures::internal::Ring>
    { typedef geofeatures::internal::RingBaseType::const_iterator type; };

} // namespace boost

#endif //__Ring_HPP_












