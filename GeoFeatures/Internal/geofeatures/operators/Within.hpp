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
    namespace operators {

        namespace detail {

            /**
             *  within implementation class.
             */
            struct within {

            private:
                /**
                 * Internal visitor class for variant access.
                 */
                class Visitor : public boost::static_visitor<bool> {

                public:

                    /**
                     * Constructor to initialize the visitor members
                     */
                    inline Visitor() : variantToPtrVariantVisitor()  {}

                    // Point
                    //
                    // Note: Point within any Geometry is implented by boost
                    //
                    bool operator()(const Point * lhs, const Point * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const LineString * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const Box * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const MultiPoint * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const MultiLineString * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    bool operator()(const Point * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }
                    
                    //
                    // LineString
                    //
                    bool operator()(const LineString * lhs, const LineString * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const LineString * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const LineString * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const LineString * lhs, const MultiLineString * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const LineString * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    //
                    // MultiLineString
                    //
                    bool operator()(const MultiLineString * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const MultiLineString * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const MultiLineString * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const MultiLineString * lhs, const LineString * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    //
                    // Ring
                    //
                    bool operator()(const Ring * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const Ring * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const Ring * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    //
                    // Polygon
                    //
                    bool operator()(const Polygon * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const Polygon * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const Polygon * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    //
                    // MultiPolygon
                    //
                    bool operator()(const MultiPolygon * lhs, const Ring * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const MultiPolygon * lhs, const Polygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    bool operator()(const MultiPolygon * lhs, const MultiPolygon * rhs) const {
                        return boost::geometry::within(*lhs, *rhs);
                    }

                    /**
                     * Generic default implementation that catches all
                     * non-implemented combinations.
                     */
                    template <typename T1, typename T2>
                    bool operator()(const T1 * lhs, const T2 * rhs) const
                    {
                        return false;
                    }

                    /**
                     * Recursive implementation of GeometryCollection type.
                     */
                    bool operator()(const GeometryCollection<> * t1, const GeometryCollection<> * t2) const {

                        for (auto it = t1->begin(); it != t1->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant1 = boost::apply_visitor(variantToPtrVariantVisitor,*it);
                            geofeatures::GeometryPtrVariant ptrVariant2(t2);

                            if (boost::apply_visitor(*this, ptrVariant1, ptrVariant2)) {
                                return true;
                            }
                        }

                        for (auto it = t2->begin(); it != t2->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant1(t1);
                            geofeatures::GeometryPtrVariant ptrVariant2  = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, ptrVariant1, ptrVariant2)) {
                                return true;
                            }
                        }
                        return false;
                    }

                    template <typename T>
                    bool operator()(const GeometryCollection<> * t1, const T * t2) const {
                        geofeatures::GeometryPtrVariant ptrVariant2(t2);

                        for (auto it = t1->begin(); it != t1->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant1 = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, ptrVariant1, ptrVariant2)) {
                                return true;
                            }
                        }
                        return false;
                    }
                    template <typename T>
                    bool operator()(const T * t1, const GeometryCollection<> * t2) const {
                        geofeatures::GeometryPtrVariant ptrVariant1(t1);

                        for (auto it = t2->begin(); it != t2->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant2 = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            if (boost::apply_visitor(*this, ptrVariant1, ptrVariant2)) {
                                return true;
                            }
                        }
                        return false;
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

                    // Members
                    VariantToPtrVariant variantToPtrVariantVisitor;
                };
                
            public:

                /**
                     * Apply the detail implementation to the variants passed.
                     */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
                static inline bool apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1,boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
                {
                    return boost::apply_visitor(Visitor(), variant1, variant2);
                }
            };

        }   // namespace detail

        /**
         * within other.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T1), BOOST_VARIANT_ENUM_PARAMS(typename T2)>
        inline bool within(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant1, boost::variant<BOOST_VARIANT_ENUM_PARAMS(T2)> const & variant2)
        {
            return detail::within::apply(variant1, variant2);
        }

    }   // namespace operators
}   // namespace geofeatures

#endif //__WithinOperation_HPP_
