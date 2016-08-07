/**
*   BoundingBox.hpp
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

#ifndef __BoundingBoxOperation_HPP_
#define __BoundingBoxOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/envelope.hpp>

#include "GeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        namespace detail {

            /**
             *  boundingBox implementation class.
             */
            struct boundingBox {

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
                class Visitor : public  boost::static_visitor<geofeatures::Box> {

                public:
                    template <typename T>
                    geofeatures::Box operator()(const T * v) const {
                        return boost::geometry::return_envelope<geofeatures::Box>(*v);
                    }

                    geofeatures::Box operator()(const GeometryCollection<> * collection) const {
                        geofeatures::Box collectionBox = boost::geometry::make_inverse<geofeatures::Box>();

                        for (auto it = collection->begin();  it != collection->end(); ++it ) {
                            geofeatures::GeometryPtrVariant ptrVariant = boost::apply_visitor(variantToPtrVariantVisitor,*it);

                            boost::geometry::expand(collectionBox, boost::apply_visitor(*this, ptrVariant));
                        }
                        return collectionBox;
                    }
                private:
                    VariantToPtrVariant variantToPtrVariantVisitor;
                };

                /**
                 * Apply the detail implementation to the variant passed.
                 */
                template <BOOST_VARIANT_ENUM_PARAMS(typename T)>
                static inline geofeatures::Box apply(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)> const & variant)
                {
                    return boost::apply_visitor(Visitor(), variant);
                }
            };
        }

        /**
         * intersect self method.
         */
        template <BOOST_VARIANT_ENUM_PARAMS(typename T)>
        inline geofeatures::Box boundingBox(boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)> const & variant)
        {
            return detail::boundingBox::apply(variant);
        }

    }   // namespace operators
}   // namespace geofeatures

#endif //__BoundingBoxOperation_HPP_
