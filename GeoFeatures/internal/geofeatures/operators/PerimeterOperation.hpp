/**
*   PerimeterOperation.hpp
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

#ifndef __PerimeterOperation_HPP_
#define __PerimeterOperation_HPP_

#include <boost/variant/variant.hpp>
#include <boost/geometry/strategies/strategies.hpp>
#include <boost/geometry/algorithms/perimeter.hpp>

#include "GFGeometryVariant.hpp"

namespace geofeatures {
    namespace operators {

        class PerimeterOperation : public  boost::static_visitor<double> {

        public:
            template <typename T>
            double operator()(const T * v) const {
                return boost::geometry::perimeter(*v);
            }

            double operator()(const GeometryCollection<> * v) const {
                return 0.0;
            }
        };

    }   // namespace operators
}   // namespace geofeatures

#endif //__PerimeterOperation_HPP_
