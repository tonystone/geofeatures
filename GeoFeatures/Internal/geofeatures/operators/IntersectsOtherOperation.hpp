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
            //
            // Intersects operation methods
            //
            bool operator()(const MultiPoint * lhs, const Ring * rhs) const {
                return false;
            }
            bool operator()(const Ring * lhs, const MultiPoint * rhs) const {
                return false;
            }
            
            bool operator()(const Polygon * lhs, const MultiPoint * rhs) const {
                return false;
            }
            bool operator()(const MultiPoint * lhs, const Polygon * rhs) const {
                return false;
            }
            
            bool operator()(const MultiPoint * lhs, const MultiPolygon * rhs) const {
                return false;
            }
            bool operator()(const MultiPolygon * lhs, const MultiPoint * rhs) const {
                return false;
            }
            
            // Generic intersects that aere implemented by boost
            template <typename T, typename TO>
            bool operator()(const T * lhs, const TO * rhs) const {
                return boost::geometry::intersects(*lhs,*rhs);
            }

            // GeometryCollection intersects
            bool operator()(const GeometryCollection<> * lhs, const GeometryCollection<> * rhs) const {
                auto variantToPtrVariantVisitor = VariantToPtrVariant();
                auto intersectsOperationVisitor = IntersectsOtherOperation();
                
                auto variantToPrVariant(boost::apply_visitor(variantToPtrVariantVisitor));
                auto intersects(boost::apply_visitor(intersectsOperationVisitor));

                for (auto it = lhs->begin();  it != lhs->end(); ++it ) {
                    geofeatures::GeometryPtrVariant lhsPtrVariant = variantToPrVariant(*it);
                    geofeatures::GeometryPtrVariant rhsPtrVariant(lhs);

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
                    geofeatures::GeometryPtrVariant rhsPtrVariant(lhs);

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
