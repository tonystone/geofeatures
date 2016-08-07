/**
*   Intersects.hpp
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
             *  intersects implementation class.
             */
            struct intersects {

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
                
                /**
                 * Internal visitor class for variant access.
                 */
                class IntersectsSelfVisitor : public  boost::static_visitor<bool> {
                    
                public:
                    /**
                     * Constructor to initialize the visitor members
                     */
                    IntersectsSelfVisitor() : variantToPtrVariantVisitor() {}
                    
                    /**
                     * Generic intersects that are implemented by boost
                     */
                    template <typename T>
                    bool operator()(const T * t) const {
                        return boost::geometry::intersects(*t);
                    }
                    
                    /*
                     * Intersects operation methods specific to 1 type
                     */
                    bool operator()(const Point * v) const {
                        return false;   // A point can't intersect itself
                    }
                    
                    bool operator()(const MultiPoint * v) const {
                        return false;   // A multipoint can't intersect itself
                    }
                    
                    bool operator()(const Box * v) const {
                        return false;   // A box can't intersect itself
                    }
                    
                    // GeometryCollection intersects
                    bool operator()(const GeometryCollection<> * collection) const {
                        
                        for (auto it = collection->begin();  it != collection->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant = boost::apply_visitor(variantToPtrVariantVisitor,*it);
                            
                            if (boost::apply_visitor(*this, ptrVariant)) {
                                return true;
                            }
                        }
                        return false;
                    }
                private:
                    VariantToPtrVariant variantToPtrVariantVisitor;
                };
                
                /**
                 * Internal visitor class for variant access.
                 */
                class IntersectsOtherVisitor : public  boost::static_visitor<bool> {

                public:
                    /**
                     * Constructor to initialize the visitor members
                     */
                    IntersectsOtherVisitor() : variantToPtrVariantVisitor() {}

                    /**
                     * Generic intersects that are implemented by boost
                     */
                    template <typename T1, typename T2>
                    bool operator()(const T1 * t1, const T2 * t2) const {
                        return boost::geometry::intersects(*t1,*t2);
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
                            geofeatures::GeometryPtrVariant lhsPtrVariant = boost::apply_visitor(variantToPtrVariantVisitor,*it);
                            geofeatures::GeometryPtrVariant rhsPtrVariant(rhs);

                            if (boost::apply_visitor(*this, lhsPtrVariant, rhsPtrVariant)) {
                                return true;
                            }
                        }

                        for (auto it = rhs->begin();  it != rhs->end(); ++it ) {
                            geofeatures::GeometryPtrVariant lhsPtrVariant(lhs);
                            geofeatures::GeometryPtrVariant rhsPtrVariant  = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, lhsPtrVariant, rhsPtrVariant)) {
                                return true;
                            }
                        }
                        return false;
                    }

                    template <typename T>
                    bool operator()(const GeometryCollection<> * lhs, const T * rhs) const {
                        geofeatures::GeometryPtrVariant rhsPtrVariant(rhs);

                        for (auto it = lhs->begin();  it != lhs->end(); ++it ) {
                            geofeatures::GeometryPtrVariant lhsPtrVariant = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, lhsPtrVariant, rhsPtrVariant)) {
                                return true;
                            }
                        }
                        return false;
                    }
                    template <typename T>
                    bool operator()(const T * lhs, const GeometryCollection<> * rhs) const {
                        geofeatures::GeometryPtrVariant lhsPtrVariant(lhs);

                        for (auto it = rhs->begin();  it != rhs->end(); ++it ) {
                            geofeatures::GeometryPtrVariant rhsPtrVariant  = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, lhsPtrVariant, rhsPtrVariant)) {
                                return true;
                            }
                        }
                        return false;
                    }
                private:
                    VariantToPtrVariant variantToPtrVariantVisitor;
                };

                /**
                 * Apply the detail implementation to the variant passed.
                 */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T)>
                static inline bool apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)> const & variant)
                {
                    return boost::apply_visitor(IntersectsSelfVisitor(), variant);
                }

                /**
                 * Apply the detail implementation to the variants passed.
                 */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
                static inline bool apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1,boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
                {
                    return boost::apply_visitor(IntersectsOtherVisitor(), variant1, variant2);
                }
            };
        }

        /**
         * intersect self method.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T)>
        inline bool intersects(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)> const & variant)
        {
            return detail::intersects::apply(variant);
        }

        /**
         * intersect other method.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
        inline bool intersects(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1, boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
        {
            return detail::intersects::apply(variant1, variant2);
        }
    }   // namespace operators
}   // namespace geofeatures

#endif //__GeoFeature_Intersects_Other_Operation_HPP_
