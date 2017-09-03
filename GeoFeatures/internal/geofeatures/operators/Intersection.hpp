/**
 *   Intersection.hpp
 *
 *   Copyright 2016 Tony Stone
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
 *   Created by Tony Stone on 4/17/16.
 *
 */

#ifndef __Intersection_HPP_
#define __Intersection_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/intersection.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {
        
        namespace detail {
            
            /**
             *  intersection implementation class.
             */
            struct intersection {
                
            private:
                /**
                 * Internal visitor class for variant access.
                 */
                class IntersectionVisitor : public boost::static_visitor<GeometryVariant> {
                    
                public:
                    
                    /**
                     * Constructor to initialize the visitor members
                     */
                    inline IntersectionVisitor() : variantToPtrVariantVisitor()  {}
                    
                    GeometryVariant operator()(const Point * lhs, const Point * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Point * lhs, const MultiPoint * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Point * lhs, const LineString * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Point * lhs, const MultiLineString * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPoint * lhs, const Point * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPoint * lhs, const MultiPoint * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPoint * lhs, const LineString * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPoint * lhs, const MultiLineString * rhs) const {
                        return intersection<MultiPoint>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const LineString * lhs, const LineString * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const LineString * lhs, const Polygon * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const LineString * lhs, const MultiLineString * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiLineString * lhs, const LineString * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiLineString * lhs, const MultiLineString * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Polygon * lhs, const Polygon * rhs) const {
                        return intersection<MultiPolygon>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Polygon * lhs, const LineString * rhs) const {
                        return intersection<MultiLineString>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const Polygon * lhs, const MultiPolygon * rhs) const {
                        return intersection<MultiPolygon>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPolygon * lhs, const Polygon * rhs) const {
                        return intersection<MultiPolygon>(lhs, rhs);
                    }
                    
                    GeometryVariant operator()(const MultiPolygon * lhs, const MultiPolygon * rhs) const {
                        return intersection<MultiPolygon>(lhs, rhs);
                    }
                    
                    /**
                     * All other geometrties and combinations are either not supported by boost
                     * or don't make sense to compute.
                     */
                    template <typename T1, typename T2>
                    GeometryVariant operator()(const T1 * t1, const T2 * t2) const {
                        throw std::invalid_argument("Invalid combination of geometry types as argument to intersection");
                    }
                    
                private:
                    template <typename O, typename T1, typename T2>
                    GeometryVariant intersection(const T1 * lhs, const T2 * rhs) const {
                        O output{};
                        
                        boost::geometry::intersection(*lhs, *rhs, output);
                        
                        if (output.size() == 1)
                            return output[0];
                        
                        return output;
                    }
                    
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
                    
                    // Members
                    VariantToPtrVariant variantToPtrVariantVisitor;
                };
                
            public:
                
                /**
                 * Apply the detail implementation to the variants passed.
                 */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
                static inline GeometryVariant apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1,boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
                {
                    return boost::apply_visitor(IntersectionVisitor(), variant1, variant2);
                }
            };
            
        }   // namespace detail
        
        /**
         * intersection other.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
        inline GeometryVariant intersection(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1, boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
        {
            return detail::intersection::apply(variant1, variant2);
        }
        
    }   // namespace operators
}   // namespace geofeatures

#endif //__Intersection_HPP_
