/**
*   WithinOperation.hpp
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
*   Created by Tony Stone on 6/11/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#ifndef __WithinOperation_HPP_
#define __WithinOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/within.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace internal {
        namespace operators {

            class WithinOperation : public  boost::static_visitor<bool> {

            public:
                // Point
                template <typename T>
                bool operator()(const Point & lhs, const T & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }

                bool operator()(const Point & lhs, const GeometryCollection & rhs) const {
                    return false;
                }

                // LineString
                bool operator()(const LineString & lhs, const LineString & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const LineString & lhs, const Ring & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const LineString & lhs, const Polygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const LineString & lhs, const MultiLineString & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const LineString & lhs, const MultiPolygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                // MultiLineString
                bool operator()(const MultiLineString & lhs, const Ring & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const MultiLineString & lhs, const Polygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const MultiLineString & lhs, const MultiPolygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const MultiLineString & lhs, const LineString & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                // Ring
                bool operator()(const Ring & lhs, const Ring & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const Ring & lhs, const Polygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const Ring & lhs, const MultiPolygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                // Polygon
                bool operator()(const Polygon & lhs, const Ring & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const Polygon & lhs, const Polygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const Polygon & lhs, const MultiPolygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                // MultiPolygon
                bool operator()(const MultiPolygon & lhs, const Ring & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const MultiPolygon & lhs, const Polygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }
                
                bool operator()(const MultiPolygon & lhs, const MultiPolygon & rhs) const {
                    return boost::geometry::within(lhs, rhs);
                }

                template <typename T, typename U>
                bool operator()( const T & lhs, const U & rhs) const
                {
                    return false;
                }

            };

        }   // namespace operators
    }   // namespace internal
}   // namespace geofeatures

#endif //__WithinOperation_HPP_
