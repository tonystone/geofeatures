/**
*   Polygon.hpp
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

#ifndef __Polygon_HPP_
#define __Polygon_HPP_

#include "Geometry.hpp"
#include "Ring.hpp"
#include "LineString.hpp"
#include "MultiLineString.hpp"
#include "MultiPoint.hpp"

#include <boost/concept/assert.hpp>

#include <boost/geometry/core/exterior_ring.hpp>
#include <boost/geometry/core/interior_rings.hpp>
#include <boost/geometry/core/point_type.hpp>
#include <boost/geometry/core/ring_type.hpp>
#include <boost/geometry/geometries/concepts/point_concept.hpp>

namespace geofeatures {
    namespace internal {
        
        /**
         * @class       Polygon
         *
         * @brief       A Polygon with an outer Ring and inner Rings or wholes.
         *
         * @author      Tony Stone
         * @date        6/9/15
         */
        class Polygon : public Geometry {

        public:

            // Member types
            typedef Point PointType;
            typedef Ring RingType;
            typedef std::vector<RingType> InnerContainerType;

            inline Polygon () : Geometry(), outer_(), inners_() {}
            inline Polygon (Polygon const & other) :  Geometry(), outer_(other.outer_), inners_(other.inners_) {}
            inline Polygon (Polygon & other)       :  Geometry(), outer_(other.outer_), inners_(other.inners_) {}

            inline virtual ~Polygon() {}

        public:
            inline RingType const & outer () const { return outer_; }
            inline InnerContainerType const & inners () const { return inners_; }

            inline RingType & outer () { return outer_; }
            inline InnerContainerType & inners () { return inners_; }

        private:
            RingType outer_;
            InnerContainerType inners_;
        };

    }   // namespace internal
}   // namespace geofeatures

namespace geofeatures_boost {
    namespace geometry {
        namespace traits {
            template<> struct tag<geofeatures::internal::Polygon> { typedef polygon_tag type; };
            template<> struct ring_const_type<geofeatures::internal::Polygon> { typedef geofeatures::internal::Polygon::RingType const& type; };
            template<> struct ring_mutable_type<geofeatures::internal::Polygon> { typedef geofeatures::internal::Polygon::RingType & type; };
            
            template<> struct interior_const_type<geofeatures::internal::Polygon> { typedef  geofeatures::internal::Polygon::InnerContainerType const& type; };
            template<> struct interior_mutable_type<geofeatures::internal::Polygon> { typedef geofeatures::internal::Polygon::InnerContainerType & type; };

            template<> struct exterior_ring<geofeatures::internal::Polygon>
            {
                static inline typename geofeatures::internal::Polygon::RingType & get(geofeatures::internal::Polygon& p)
                {
                    return p.outer();
                }

                static inline typename geofeatures::internal::Polygon::RingType const& get(geofeatures::internal::Polygon const& p)
                {
                    return p.outer();
                }
            };

            template<> struct interior_rings<geofeatures::internal::Polygon>
            {
                static inline typename geofeatures::internal::Polygon::InnerContainerType & get(geofeatures::internal::Polygon& p)
                {
                    return p.inners();
                }

                static inline typename geofeatures::internal::Polygon::InnerContainerType const& get(geofeatures::internal::Polygon const& p)
                {
                    return p.inners();
                }
            };
        }
    }
} // namespace boost::geometry::traits

#endif //__Polygon_HPP_


