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
        
        namespace detail {
            /**
* @class       IntersectsSelfOperation
*
* @brief       Operation to test for self intersection.
*
* @author      Tony Stone
* @date        10/6/15
*/
            struct IntersectsOtherVisitor : public  boost::static_visitor<bool> {

                /**
                 * Generic intersects that are implemented by boost
                 */
                template <typename T, typename TO>
                bool operator()(const T * lhs, const TO * rhs) const {
                    return boost::geometry::intersects(*lhs,*rhs);
                }

                /*
                 * Intersects operation methods specific to 2 types
                 */

                /**
                 * Generic template for MultiType to single type intersects
                 */
                template<typename MultiType, typename SingleType>
                inline bool multiIntersects(const MultiType * multiType, const SingleType * singleType) const {
                    //
                    // If any point in the item in the multi intersects the other geometry,
                    // we have an intersection.
                    //
                    for (auto it = multiType->begin(); it != multiType->end(); it++) {
                        if (boost::geometry::intersects(*it,*singleType)) {
                            return true;
                        }
                    }
                    return false;
                }

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
                    geofeatures::GeometryPtrVariant rhsPtrVariant(rhs);

                    for (auto it = lhs->begin();  it != lhs->end(); ++it ) {
                        geofeatures::GeometryPtrVariant lhsPtrVariant = variantToPrVariant(*it);

                        if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                            return true;
                        }
                    }
                    return false;
                }
                template <typename T>
                bool operator()(const T * lhs, const GeometryCollection<> * rhs) const {
                    geofeatures::GeometryPtrVariant lhsPtrVariant(lhs);

                    for (auto it = rhs->begin();  it != rhs->end(); ++it ) {
                        geofeatures::GeometryPtrVariant rhsPtrVariant  = variantToPrVariant(*it);

                        if (intersects(lhsPtrVariant, rhsPtrVariant)) {
                            return true;
                        }
                    }
                    return false;
                }

                /**
                 * Constructor to initialize the visitor memmbers
                 */
                IntersectsOtherVisitor()
                        : variantToPtrVariantVisitor(), variantToPrVariant(variantToPtrVariantVisitor), intersects(*this) {
                }

            private:
                /**
                 * Internal class to convert from GeometryCollection variant
                 * to the GeometryPtrVariant type.
                 */
                struct VariantToPtrVariant : public boost::static_visitor<GeometryPtrVariant> {
                    template <typename T>
                    GeometryPtrVariant operator()(const T & v) const {
                        return GeometryPtrVariant(&v);
                    }
                };

                //
                // Members
                //
                VariantToPtrVariant variantToPtrVariantVisitor;

                boost::apply_visitor_delayed_t<VariantToPtrVariant> variantToPrVariant;
                boost::apply_visitor_delayed_t<IntersectsOtherVisitor> intersects;
            };
        }

        /**
         * intersect other method.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
        inline bool intersects(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1, boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
        {

            return boost::apply_visitor(detail::IntersectsOtherVisitor(), variant1, variant2);
        }
    }   // namespace operators
}   // namespace geofeatures

#endif //__GeoFeature_Intersects_Other_Operation_HPP_
