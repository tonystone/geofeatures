/**
*   MultiLineString.hpp
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
*   Created by Tony Stone on 6/9/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/
#pragma once

#ifndef __MultiLineString_HPP_
#define __MultiLineString_HPP_

#include "Geometry.hpp"
#include "LineString.hpp"
#include "Collection.hpp"

#include <boost/concept/requires.hpp>

#include <boost/geometry/core/tags.hpp>
#include <boost/geometry/geometries/concepts/linestring_concept.hpp>


namespace geofeatures {

    /**
    * @class       MultiLineString
    *
    * @brief       A Collection of LineStrings.
    *
    * @author      Tony Stone
    * @date        6/9/15
    */
    class MultiLineString : public Geometry, public Collection <geofeatures::LineString> {

    private:
        typedef Collection <geofeatures::LineString> BaseType;

    public:
        inline MultiLineString () noexcept : Geometry(), BaseType() {}
        inline virtual ~MultiLineString() noexcept {};
    };

}   // namespace geofeatures

namespace geofeatures_boost {
        namespace geometry {
            namespace traits
            {
                template<>
                struct tag<geofeatures::MultiLineString> {
                    typedef multi_linestring_tag type;
                };
            }
        } // namespace geometry::traits

        template<>
        struct range_iterator<geofeatures::MultiLineString>
        { typedef typename geofeatures::MultiLineString::iterator type; };

        template<>
        struct range_const_iterator<geofeatures::MultiLineString>
        { typedef typename geofeatures::MultiLineString::const_iterator type; };

} // namespace boost

#endif //__MultiLineString_HPP_
