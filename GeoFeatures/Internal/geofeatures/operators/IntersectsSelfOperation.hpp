/**
*   IntersectsOperation.hpp
*
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
*   Created by Tony Stone on 10/6/15.
*/

#ifndef __GeoFeature_Intersects_Operation_HPP_
#define __GeoFeature_Intersects_Operation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/intersects.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        /**
         * @class       IntersectsSelfOperation
         *
         * @brief       Operation to test for self intersection.
         *
         * @author      Tony Stone
         * @date        10/6/15
         */
        struct IntersectsSelfOperation : public  boost::static_visitor<bool> {

            //
            // Internal class to convert from GeometryCollection variant
            // to the GeometryPtrVariant type.
            //
            struct VariantToPtrVariant : public boost::static_visitor<GeometryPtrVariant> {
                template <typename T>
                GeometryPtrVariant operator()(const T & v) const {
                    return GeometryPtrVariant(&v);
                }
            };
            //
            // Intersects operation methods
            //

            // Generic intersects
            template <typename T>
            bool operator()(const T * v) const {
                // All other types can't intersect themselves for instance a point.
                return false;
            }
            // Specific intersects
            bool operator()(const LineString * v) const {
                return boost::geometry::intersects(*v);
            }
            bool operator()(const Ring * v) const {
                return boost::geometry::intersects(*v);
            }
            bool operator()(const Polygon * v) const {
                return boost::geometry::intersects(*v);
            }
            bool operator()(const MultiLineString * v) const {
                return boost::geometry::intersects(*v);
            }
            bool operator()(const MultiPolygon * v) const {
                return boost::geometry::intersects(*v);
            }
            // GeometryCollection intersects
            bool operator()(const GeometryCollection<> * v) const {
                auto variantToPtrVariantVisitor = VariantToPtrVariant();
                auto intersectsOperationVisitor = IntersectsSelfOperation();

                auto variantToPrVariant  = boost::apply_visitor(variantToPtrVariantVisitor);
                auto intersects          = boost::apply_visitor(intersectsOperationVisitor);

                for (auto it = v->begin();  it != v->end(); ++it ) {
                    geofeatures::GeometryPtrVariant ptrVariant = variantToPrVariant(*it);

                    if (intersects(ptrVariant)) {
                        return true;
                    }
                }
                return false;
            }
        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__GeoFeature_Intersects_Operation_HPP_
