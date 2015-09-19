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

#ifndef __MultiLineString_HPP_
#define __MultiLineString_HPP_

#include "Geometry.hpp"
#include "LineString.hpp"

#include <boost/concept/requires.hpp>

#include <boost/geometry/core/tags.hpp>
#include <boost/geometry/geometries/concepts/linestring_concept.hpp>
#include <vector>

namespace geofeatures {

    /**
    * Base type for MultiLineString class
    */
    typedef std::vector<geofeatures::LineString> MultiLineStringBaseType;

    /**
    * @class       MultiLineString
    *
    * @brief       A Collection of LineStrings.
    *
    * @author      Tony Stone
    * @date        6/9/15
    */
    class MultiLineString : public Geometry, public MultiLineStringBaseType {

    public:
        inline MultiLineString () : Geometry(), MultiLineStringBaseType() {}
        inline virtual ~MultiLineString() {};
    };

    /** @defgroup BoostRangeIterators
    *
    * @{
    */
    inline MultiLineStringBaseType::iterator range_begin(MultiLineString& mls) {return mls.begin();}
    inline MultiLineStringBaseType::iterator range_end(MultiLineString& mls) {return mls.end();}
    inline MultiLineStringBaseType::const_iterator range_begin(const MultiLineString& mls) {return mls.begin();}
    inline MultiLineStringBaseType::const_iterator range_end(const MultiLineString& mls) {return mls.end();}
    /** @} */

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
        { typedef geofeatures::MultiLineStringBaseType::iterator type; };

        template<>
        struct range_const_iterator<geofeatures::MultiLineString>
        { typedef geofeatures::MultiLineStringBaseType::const_iterator type; };

} // namespace boost

#endif //__MultiLineString_HPP_
