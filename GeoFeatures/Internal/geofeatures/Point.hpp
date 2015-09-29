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
#pragma once

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
        static const std::size_t dimensionCount = 2;
        enum { cs_check = sizeof(CoordinateSystem) };

    public:
        // construction/destruction
        inline Point(CoordinateType const& x = 0.0, CoordinateType const& y = 0.0) noexcept : Geometry() {
            values_[0] = x;
            values_[1] = y;
        }

        inline virtual ~Point() noexcept {};

        template <std::size_t K>
        inline CoordinateType const& get() const noexcept {
            static_assert(K < dimensionCount, "Index out of bounds");
            return values_[K];
        }

        template <std::size_t K>
        inline void set(CoordinateType const& value) noexcept {
            static_assert(K < dimensionCount, "Index out of bounds");
            values_[K] = value;
        }

    private:
        CoordinateType values_[dimensionCount];
    };

}   // namespace geofeatures


namespace geofeatures_boost {
    namespace geometry {
        namespace traits {
            // Adapt geofeatures::Point to Boost.Geometry

            template<> struct tag<geofeatures::Point>
            { typedef point_tag type; };

            template<> struct coordinate_type<geofeatures::Point>
            { typedef geofeatures::Point::CoordinateType type; };

            template<> struct coordinate_system<geofeatures::Point>
            { typedef geofeatures::Point::CoordinateSystem type; };

            template<> struct dimension<geofeatures::Point> : boost::mpl::int_<2> {};

            template<>
            struct access<geofeatures::Point, 0>
            {
                static inline geofeatures::Point::CoordinateType get(geofeatures::Point const& p) {
                    return p.template get<0>();
                }

                static inline void set(geofeatures::Point& p, geofeatures::Point::CoordinateType const& value) {
                    p.template set<0>(value);
                }
            };

            template<>
            struct access<geofeatures::Point, 1>
            {
                static inline geofeatures::Point::CoordinateType get(geofeatures::Point const& p) {
                    return p.template get<1>();
                }

                static inline void set(geofeatures::Point& p, geofeatures::Point::CoordinateType const& value) {
                    p.template set<1>(value);
                }
            };
        }
    }
} // namespace boost::geometry::traits

#endif //__Point_HPP_
