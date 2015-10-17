/**
*   IntersectsOtherOperation.hpp
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

#ifndef __GeoFeature_Intersects_Other_Operation_HPP_
#define __GeoFeature_Intersects_Other_Operation_HPP_

#include <boost/variant/apply_visitor.hpp>
#include <boost/variant/static_visitor.hpp>
#include <boost/variant/variant_fwd.hpp>

#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/intersects.hpp>

#include <boost/geometry/geometries/concepts/check.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {
        
        /**
         * Free function template to apply intersection to a multiType to
         * another type.
         */
        template<typename T1, typename T2>
        inline bool multiIntersects(const T1 * t1, const T2 * t2) {
            //
            // If any point in the item in the multi intersects the other geoemtry,
            // we have an intersection.
            //
            for (auto it = t1->begin(); it != t1->end(); it++) {
                if (boost::geometry::intersects(*it,*t2)) {
                    return true;
                }
            }
            return false;
        };

        /**
         * @class       IntersectsSelfOperation
         *
         * @brief       Operation to test for self intersection.
         *
         * @author      Tony Stone
         * @date        10/6/15
         */
        struct IntersectsOtherOperation : public  boost::static_visitor<bool> {

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

            // Generic intersects that are implemented by boost
            template <typename T, typename TO>
            bool operator()(const T * lhs, const TO * rhs) const {
                return boost::geometry::intersects(*lhs,*rhs);
            }

            //
            // Intersects operation methods specific to 2 types
            //
            bool operator()(const MultiPoint * multiPoint, const Ring * ring) const {
                return multiIntersects(multiPoint,ring);
            }

            bool operator()(const Ring * ring, const MultiPoint * multiPoint) const {
                // reverse them and use the multiIntersect
                return multiIntersects(multiPoint,ring);
            }
            
            bool operator()(const Polygon * polygon, const MultiPoint * multiPoint) const {
                // reverse them and use the multiIntersect
                return multiIntersects(multiPoint,polygon);
            }

            bool operator()(const MultiPoint * multiPoint, const Polygon * polygon) const {
                return multiIntersects(multiPoint,polygon);
            }
            
            bool operator()(const MultiPoint * multiPoint, const MultiPolygon * multiPolygon) const {
                return multiIntersects(multiPoint,multiPolygon);
            }

            bool operator()(const MultiPolygon * multiPolygon, const MultiPoint * multiPoint) const {
                // reverse them and use the multiIntersect
                return multiIntersects(multiPoint,multiPolygon);
            }

            bool operator()(const GeometryCollection<> * lhs, const GeometryCollection<> * rhs) const {
                auto variantToPtrVariantVisitor = VariantToPtrVariant();
                auto intersectsOperationVisitor = IntersectsOtherOperation();
                
                auto variantToPrVariant(boost::apply_visitor(variantToPtrVariantVisitor));
                auto intersects(boost::apply_visitor(intersectsOperationVisitor));

                for (auto it = lhs->begin();  it != lhs->end(); ++it ) {
                    geofeatures::GeometryPtrVariant lhsPtrVariant = variantToPrVariant(*it);
                    geofeatures::GeometryPtrVariant rhsPtrVariant(rhs);

                    if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                        return true;
                    }
                }

                for (auto it = rhs->begin();  it != rhs->end(); ++it ) {
                    geofeatures::GeometryPtrVariant lhsPtrVariant(lhs);
                    geofeatures::GeometryPtrVariant rhsPtrVariant  = variantToPrVariant(*it);

                    if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                        return true;
                    }
                }
                return false;
            }

            template <typename T>
            bool operator()(const GeometryCollection<> * lhs, const T * rhs) const {
                auto variantToPtrVariantVisitor = VariantToPtrVariant();
                auto intersectsOperationVisitor = IntersectsOtherOperation();

                auto variantToPrVariant(boost::apply_visitor(variantToPtrVariantVisitor));
                auto intersects(boost::apply_visitor(intersectsOperationVisitor));


                for (auto it = lhs->begin();  it != lhs->end(); ++it ) {
                    geofeatures::GeometryPtrVariant lhsPtrVariant = variantToPrVariant(*it);
                    geofeatures::GeometryPtrVariant rhsPtrVariant(rhs);

                    if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                        return true;
                    }
                }
                return false;
            }
            template <typename T>
            bool operator()(const T * lhs, const GeometryCollection<> * rhs) const {
                auto variantToPtrVariantVisitor = VariantToPtrVariant();
                auto intersectsOperationVisitor = IntersectsOtherOperation();

                auto variantToPrVariant(boost::apply_visitor(variantToPtrVariantVisitor));
                auto intersects(boost::apply_visitor(intersectsOperationVisitor));


                for (auto it = rhs->begin();  it != rhs->end(); ++it ) {
                    geofeatures::GeometryPtrVariant lhsPtrVariant(lhs);
                    geofeatures::GeometryPtrVariant rhsPtrVariant  = variantToPrVariant(*it);

                    if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                        return true;
                    }
                }
                return false;
            }
        };
    }   // namespace operators
}   // namespace geofeatures

#endif //__GeoFeature_Intersects_Other_Operation_HPP_
