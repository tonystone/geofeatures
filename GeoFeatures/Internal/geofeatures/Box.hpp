/**
*   Box.hpp
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
*   Created by Tony Stone on 6/16/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#pragma once

#ifndef __Box_HPP_
#define __Box_HPP_

#include "Geometry.hpp"
#include "Point.hpp"

#include <boost/concept/assert.hpp>
#include <boost/geometry/core/access.hpp>
#include <boost/geometry/core/coordinate_type.hpp>
#include <boost/geometry/core/coordinate_system.hpp>
#include <boost/geometry/core/coordinate_dimension.hpp>
#include <boost/geometry/core/cs.hpp>

#include <boost/geometry/geometries/concepts/point_concept.hpp>
#include <boost/geometry/algorithms/convert.hpp>


namespace geofeatures {

    /**
     * @class       Box
     *
     * @brief       A Box with 2 corner points, min and max.
     *
     * @author      Tony Stone
     * @date        6/16/15
     */
    class Box : public Geometry {

    public:
        // construction/destruction
        inline Box() noexcept : Geometry(), minCorner_(), maxCorner_() {}
        inline Box(Point const& minCorner, Point const& maxCorner) noexcept : Geometry(), minCorner_(minCorner), maxCorner_(maxCorner) {}
        inline virtual ~Box() noexcept {};

        inline Point const& minCorner() const noexcept { return minCorner_; }
        inline Point const& maxCorner() const noexcept { return maxCorner_; }

        inline Point& minCorner() noexcept { return minCorner_; }
        inline Point& maxCorner() noexcept { return maxCorner_; }

    private:
        Point minCorner_;
        Point maxCorner_;
    };

}   // namespace geofeatures


namespace geofeatures_boost {
    namespace geometry {
        namespace traits {
            // Adapt geofeatures::Box to Boost.Geometry

            template <> struct tag<geofeatures::Box>
            {  typedef box_tag type; };

            template <> struct point_type<geofeatures::Box>
            { typedef geofeatures::Point type; };

            template <std::size_t Dimension>
            struct indexed_access<geofeatures::Box, min_corner, Dimension>
            {
                typedef typename geometry::coordinate_type<geofeatures::Point>::type coordinate_type;

                static inline coordinate_type get(geofeatures::Box const& b)
                {
                    return geometry::get<Dimension>(b.minCorner());
                }

                static inline void set(geofeatures::Box& b, coordinate_type const& value)
                {
                    geometry::set<Dimension>(b.minCorner(), value);
                }
            };

            template <std::size_t Dimension>
            struct indexed_access<geofeatures::Box, max_corner, Dimension>
            {
                typedef typename geometry::coordinate_type<geofeatures::Point>::type coordinate_type;

                static inline coordinate_type get(geofeatures::Box const& b)
                {
                    return geometry::get<Dimension>(b.maxCorner());
                }

                static inline void set(geofeatures::Box& b, coordinate_type const& value)
                {
                    geometry::set<Dimension>(b.maxCorner(), value);
                }
            };

        }  // namespace traits
    } // namespace geometry
} // namespace boost

#endif //__Box_HPP_
