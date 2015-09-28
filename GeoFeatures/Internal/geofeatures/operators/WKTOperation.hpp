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
#include "WriteWKT.hpp"

namespace geofeatures {
    namespace operators {

        class WKTOperation : public  boost::static_visitor<std::string> {

        public:
            template <typename T>
            std::string operator()(const T * v) const {

                std::stringstream stringStream;
                stringStream << boost::geometry::wkt<T>(*v);

                return stringStream.str();
            }

            std::string operator()(const GeometryCollection<> * v) const {

                std::stringstream stringStream;
                stringStream << io::wkt<GeometryCollection<>>(*v);

                return stringStream.str();
            }
        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__WKTOperation_HPP_
