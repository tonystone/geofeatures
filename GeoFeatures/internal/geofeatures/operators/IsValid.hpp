/**
*   IsValidOperation.hpp
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

#ifndef __IsValidOperation_HPP_
#define __IsValidOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/is_valid.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        namespace detail {

            /**
             *  isValid implementation class.
             */
            struct isValid {

                /**
                 * Internal visitor class for variant access.
                 */
                class Visitor : public boost::static_visitor<bool> {

                public:
                    
                    /**
                     * Constructor to initialize the visitor memmbers
                     */
                    inline Visitor() : variantToPtrVariantVisitor()  {}
                    
                    /**
                     * Main implementation for types known to boost.
                     */
                    template <typename T>
                    bool operator()(const T * v) const {
                        return boost::geometry::is_valid(*v);
                    }

                    /**
                     * Recursive implementation of GeometryCollection type.
                     */
                    bool operator()(const GeometryCollection<> * collection) const {

                        for (auto it = collection->begin(); it != collection->end(); ++it ) {
                            const geofeatures::GeometryPtrVariant variant = boost::apply_visitor(variantToPtrVariantVisitor,*it);
                            
                            if (!boost::apply_visitor(*this, variant)) {
                                return false;
                            }
                        }
                        return true;
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

                /**
                 * Apply the detail implementation to the variant passed.
                 */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T1)>
                static inline bool apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant)
                {
                    return boost::apply_visitor(Visitor(), variant);
                }
            };
            
    }   // namespace detail

    /**
     * area algorithm.
     */
    template <BOOST_VARIANT_ENUM_PARAMS(typename T1)>
    inline bool isValid(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T1)> const & variant)
    {
        return detail::isValid::apply(variant);
    }


    }   // namespace operators
}   // namespace geofeatures

#endif //__IsValidperator_HPP_
