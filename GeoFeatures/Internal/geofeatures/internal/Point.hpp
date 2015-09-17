/**
*   Point.hpp
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

#ifndef __Point_HPP_
#define __Point_HPP_

#include "Geometry.hpp"

#include <boost/mpl/int.hpp>
#include <boost/static_assert.hpp>

#include <boost/geometry/core/access.hpp>
#include <boost/geometry/core/coordinate_type.hpp>
#include <boost/geometry/core/coordinate_system.hpp>
#include <boost/geometry/core/coordinate_dimension.hpp>
#include <boost/geometry/core/cs.hpp>

#include <boost/geometry/geometries/concepts/point_concept.hpp>

namespace geofeatures {
    namespace internal {
        
        /**
         * @class       Point
         *
         * @brief       A simple 2d point.
         *
         * @author      Tony Stone
         * @date        6/9/15
         */
        class Point : public Geometry {

        public:
            // member types
            typedef double CoordinateType;
            typedef boost::geometry::cs::cartesian CoordinateSystem;

        private:
            enum { cs_check = sizeof(CoordinateSystem) };
            
        public:
            // construction/destruction
            inline Point(CoordinateType const& x = 0.0, CoordinateType const& y = 0.0) : Geometry() {
                values_[0] = x;
                values_[1] = y;
            }

            inline virtual ~Point() {};

            template <std::size_t K>
            inline CoordinateType const& get() const {
                return values_[K];
            }

            template <std::size_t K>
            inline void set(CoordinateType const& value){
                values_[K] = value;
            }

        private:
            CoordinateType values_[2];
        };

    }   // namespace internal
}   // namespace geofeatures


namespace geofeatures_boost {
    namespace geometry {
        namespace traits {
            // Adapt geofeatures::internal::Point to Boost.Geometry

            template<> struct tag<geofeatures::internal::Point>
            { typedef point_tag type; };

            template<> struct coordinate_type<geofeatures::internal::Point>
            { typedef geofeatures::internal::Point::CoordinateType type; };

            template<> struct coordinate_system<geofeatures::internal::Point>
            { typedef geofeatures::internal::Point::CoordinateSystem type; };

            template<> struct dimension<geofeatures::internal::Point> : boost::mpl::int_<2> {};

            template<>
            struct access<geofeatures::internal::Point, 0>
            {
                static inline geofeatures::internal::Point::CoordinateType get(geofeatures::internal::Point const& p) {
                    return p.template get<0>();
                }

                static inline void set(geofeatures::internal::Point& p, geofeatures::internal::Point::CoordinateType const& value) {
                    p.template set<0>(value);
                }
            };

            template<>
            struct access<geofeatures::internal::Point, 1>
            {
                static inline geofeatures::internal::Point::CoordinateType get(geofeatures::internal::Point const& p) {
                    return p.template get<1>();
                }

                static inline void set(geofeatures::internal::Point& p, geofeatures::internal::Point::CoordinateType const& value) {
                    p.template set<1>(value);
                }
            };
        }
    }
} // namespace boost::geometry::traits

#endif //__Point_HPP_