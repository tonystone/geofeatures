/**
*   UnionOperation.hpp
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

#ifndef __UnionOperation_HPP_
#define __UnionOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/union.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        class UnionOperation : public  boost::static_visitor<GeometryVariant> {

        public:
            GeometryVariant operator()(const Point * lhs, const Point * rhs) const {
                return singleTypeUnion<MultiPoint>(lhs, rhs);
            }

            GeometryVariant operator()(const Point * lhs, const MultiPoint * rhs) const {
                return multiTypeUnion<MultiPoint>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiPoint * lhs, const Point * rhs) const {
                return multiTypeUnion<MultiPoint>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiPoint * lhs, const MultiPoint * rhs) const {
                return singleTypeUnion<MultiPoint>(lhs, rhs);
            }

            GeometryVariant operator()(const LineString * lhs, const LineString * rhs) const {
                return singleTypeUnion<MultiLineString>(lhs, rhs);
            }

            GeometryVariant operator()(const LineString * lhs, const MultiLineString * rhs) const {
                return multiTypeUnion<MultiLineString>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiLineString * lhs, const LineString * rhs) const {
                return multiTypeUnion<MultiLineString>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiLineString * lhs, const MultiLineString * rhs) const {
                return singleTypeUnion<MultiLineString>(lhs, rhs);
            }

            GeometryVariant operator()(const Polygon * lhs, const Polygon * rhs) const {
                return singleTypeUnion<MultiPolygon>(lhs, rhs);
            }

            GeometryVariant operator()(const Polygon * lhs, const MultiPolygon * rhs) const {
                return multiTypeUnion<MultiPolygon>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiPolygon * lhs, const Polygon * rhs) const {
                return multiTypeUnion<MultiPolygon>(lhs, rhs);
            }

            GeometryVariant operator()(const MultiPolygon * lhs, const MultiPolygon * rhs) const {
                return singleTypeUnion<MultiPolygon>(lhs, rhs);
            }

            GeometryVariant operator()(const Ring * lhs, const Ring * rhs) const {
                std::vector<Ring> tmp;

                boost::geometry::union_(*lhs, *rhs, tmp);

                if (tmp.size() == 1) {
                    return tmp.front();
                }

                GeometryCollection<> output;
                for (auto it = tmp.begin(); it != tmp.end(); ++it) {
                    output.push_back(*it);
                }
                return output;
            }

            //
            // For GeometryCollections the initial implemention of these
            // is a simple combination of the right and left hand sides.
            //
            GeometryVariant operator()( const GeometryCollection<> * lhs, const GeometryCollection<> * rhs) const {
                GeometryCollection<> output(*lhs);

                std::for_each(rhs->begin(), rhs->end(), [&output](const GeometryCollection<>::value_type & item) {
                                  output.push_back(item);
                              });
                return output;
            }

            template <typename T>
            GeometryVariant operator()( const T * lhs, const GeometryCollection<> * rhs) const {
                return this->operator()(rhs, lhs);  // Reverse order and chain to reverse order method
            }

            template <typename T>
            GeometryVariant operator()( const GeometryCollection<> * lhs, const T * rhs) const {
                GeometryCollection<> output(*lhs);

                output.push_back(*rhs);

                return output;
            }

            template <typename T, typename U>
            GeometryVariant operator()( const T * lhs, const U * rhs) const {
                GeometryCollection<> collection;

                collection.push_back(*lhs);
                collection.push_back(*rhs);

                return collection;
            }

        private:
            template <typename OT, typename T>
            GeometryVariant singleTypeUnion( const T * lhs, const T * rhs) const {
                OT output{};

                boost::geometry::union_(*lhs, *rhs, output);

                if (output.size() == 1)
                    return output[0];
                else if (output.size() > 1)
                    return output;

                return T(*lhs);
            }

            template <typename OT, typename T, typename U>
            GeometryVariant multiTypeUnion( const T * lhs, const U * rhs) const {
                OT output{};

                boost::geometry::union_(*lhs, *rhs, output);

                return output;
            }

        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__UnionOperator_HPP_
