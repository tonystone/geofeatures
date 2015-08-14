/**
*   Box.hpp
*
*   Copyright 2015 The Climate Corporation
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
*/


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


namespace climate {
    namespace gf {
        
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
            inline Box() : Geometry(), minCorner_(), maxCorner_() {}
            // construction/destruction
            inline Box(Point const& minCorner, Point const& maxCorner)
            {
                // Convert to the coordinate system of this box
                boost::geometry::convert(minCorner, minCorner_);
                boost::geometry::convert(maxCorner, maxCorner_);
            }
            inline virtual ~Box() {};

            inline Point const& minCorner() const { return minCorner_; }
            inline Point const& maxCorner() const { return maxCorner_; }

            inline Point& minCorner() { return minCorner_; }
            inline Point& maxCorner() { return maxCorner_; }

        private:
            Point minCorner_;
            Point maxCorner_;
        };

    }   // namespace gf
}   // namespace climate


namespace boost {
    namespace geometry {
        namespace traits {
            // Adapt climate::gf::Box to Boost.Geometry

            template <> struct tag<climate::gf::Box>
            {  typedef box_tag type; };

            template <> struct point_type<climate::gf::Box>
            { typedef climate::gf::Point type; };

            template <std::size_t Dimension>
            struct indexed_access<climate::gf::Box, min_corner, Dimension>
            {
                typedef typename geometry::coordinate_type<climate::gf::Point>::type coordinate_type;

                static inline coordinate_type get(climate::gf::Box const& b)
                {
                    return geometry::get<Dimension>(b.minCorner());
                }

                static inline void set(climate::gf::Box& b, coordinate_type const& value)
                {
                    geometry::set<Dimension>(b.minCorner(), value);
                }
            };

            template <std::size_t Dimension>
            struct indexed_access<climate::gf::Box, max_corner, Dimension>
            {
                typedef typename geometry::coordinate_type<climate::gf::Point>::type coordinate_type;

                static inline coordinate_type get(climate::gf::Box const& b)
                {
                    return geometry::get<Dimension>(b.maxCorner());
                }

                static inline void set(climate::gf::Box& b, coordinate_type const& value)
                {
                    geometry::set<Dimension>(b.maxCorner(), value);
                }
            };

        }  // namespace traits
    } // namespace geometry
} // namespace boost

#endif //__Box_HPP_
