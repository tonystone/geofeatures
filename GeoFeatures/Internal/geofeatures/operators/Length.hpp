/**
*   LengthOperation.hpp
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
#pragma once

#ifndef __GeoFeatures_Length_HPP_
#define __GeoFeatures_Length_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/length.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        namespace detail {

            /**
             *  length implementation class.
             */
            struct length {

                class Visitor : public  boost::static_visitor<double> {

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

                    VariantToPtrVariant variantToPtrVariantVisitor;

                public:
                    template <typename T>
                    double operator()(const T * v) const {
                        return boost::geometry::length(*v);
                    }

                    double operator()(const GeometryCollection<> * collection) const {
                        double length = 0.0;

                        for (auto it = collection->begin(); it != collection->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            length += boost::apply_visitor(*this, ptrVariant);
                        }
                        return length;
                    }
                };

                template <BOOST_VARIANT_ENUM_PARAMS(typename T1)>
                static inline double apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant)
                {
                    return boost::apply_visitor(Visitor(), variant);
                }
            };
        }   // namespace detail

        /**
         * length algorithm.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T1)>
        inline double length(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant)
        {
            return detail::length::apply(variant);
        }
    }   // namespace operators
}   // namespace geofeatures

#endif //__GeoFeatures_Length_HPP_
