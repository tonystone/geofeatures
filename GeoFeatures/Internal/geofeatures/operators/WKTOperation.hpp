/**
*   WKTOperation.hpp
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

#ifndef __WKTOperation_HPP_
#define __WKTOperation_HPP_

#include "GeometryVariant.hpp"
#include <boost/geometry/io/wkt/wkt.hpp>

namespace geofeatures {
    namespace operators {

        /**
         * @class       WKTOperation
         *
         * @brief       Operation to convert any geofeatures model type into a wkt string.
         *
         * @author      Tony Stone
         * @date        10/4/15
         */
        struct  WKTOperation : public  boost::static_visitor<std::string> {

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

            // WKT operation methods
            template <typename T>
            std::string operator()(const T * v) const {

                std::stringstream stringStream;
                stringStream << boost::geometry::wkt<T>(*v);

                return stringStream.str();
            }

            std::string operator()(const Ring * v) const {
                // Ring is currently getting special treatment
                // because we want it to be represented as
                // a LineString in WKT terms.
                //
                // Boost will product a Polygon if sent through
                // as a Ring type.
                //
                gf::LineString lineString(*v);

                std::stringstream stringStream;
                stringStream << boost::geometry::wkt<gf::LineString>(lineString);

                return stringStream.str();
            }

            std::string operator()(const GeometryCollection<> * v) const {

                std::stringstream stringStream;
                stringStream << "GEOMETRYCOLLECTION";

                if ((*v).size() > 0) {
                    stringStream << "(";

                    bool first = true;
                    auto variantToPtrVariantVisitor = VariantToPtrVariant();
                    auto wktOperationVisitor        = WKTOperation();

                    auto variantToPrVariant         = boost::apply_visitor(variantToPtrVariantVisitor);
                    auto variantToWKT               = boost::apply_visitor(wktOperationVisitor);

                    for (auto it = (*v).begin();  it != (*v).end(); ++it ) {
                        gf::GeometryPtrVariant ptrVariant = variantToPrVariant(*it);

                        if (!first) {
                            stringStream << ",";
                        }
                        //
                        // Recursively call ourself for
                        // each variant in the collection.
                        //
                        stringStream << variantToWKT(ptrVariant);
                        first = false;
                    }
                    stringStream << ")";
                } else {
                    stringStream << "()";  // EMPTY
                }
                return stringStream.str();
            }
        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__WKTOperation_HPP_
