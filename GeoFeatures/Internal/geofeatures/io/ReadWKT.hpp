/**
*   ReadWKT.hpp
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
*   Created by Tony Stone on 6/13/15.
*
*   MODIFIED 2015 BY Tony Stone. Modifications licensed under Apache License, Version 2.0.
*
*/

#ifndef __ReadWKT_HPP_
#define __ReadWKT_HPP_

#include "GeometryCollection.hpp"
#include <boost/geometry/io/wkt/read.hpp>
#include <boost/algorithm/string/trim.hpp>
#include <boost/algorithm/string/replace.hpp>
#include <boost/algorithm/string/erase.hpp>
#include <boost/algorithm/string/find_iterator.hpp>

#include <regex>

namespace geofeatures {
    namespace io {

        template <typename Geometry, typename = typename std::enable_if<std::is_same<Geometry,GeometryCollection<>>::value>::type>
        inline void readWKT(std::string const &wkt, Geometry &geometryCollection)
        {
            if (!boost::istarts_with(wkt, "GEOMETRYCOLLECTION")) {
                throw std::invalid_argument("Should start with 'GEOMETRYCOLLECTION'' in (" + wkt + ")");
            }

            GeometryCollection<>::value_type (*geometry)(std::string & wkt) =
                    [](std::string & wkt) -> GeometryCollection<>::value_type {

                        if (boost::istarts_with(wkt, "POINT")) {
                            geofeatures::Point geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        } else if (boost::istarts_with(wkt, "MULTIPOINT")) {
                            geofeatures::MultiPoint geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        } else if (boost::istarts_with(wkt, "LINESTRING")) {
                            geofeatures::LineString geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        } else if (boost::istarts_with(wkt, "MULTILINESTRING")) {
                            geofeatures::MultiLineString geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        } else if (boost::istarts_with(wkt, "POLYGON")) {
                            geofeatures::Polygon geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        } else if (boost::istarts_with(wkt, "MULTIPOLYGON")) {
                            geofeatures::MultiPolygon geometry;

                            boost::geometry::read_wkt(wkt, geometry);

                            return geometry;
                        }
                        return GeometryCollection<>::value_type();
                    };

            std::regex words_regex("\\b(EMPTY|POINT|MULTIPOINT|LINESTRING|MULTILINESTRING|POLYGON|MULTIPOLYGON)", std::regex_constants::icase);

            std::string::const_iterator collectionBegin = wkt.begin();
            std::string::const_iterator collectionEnd   = wkt.end();

            long beginOffset = wkt.find_first_of("(");
            long endPosition = wkt.find_last_of(")");

            std::advance(collectionBegin, beginOffset);

            auto words_begin = std::sregex_iterator(collectionBegin, collectionEnd, words_regex);
            auto words_end = std::sregex_iterator();

            long beginPosition = beginOffset;;

            for (std::sregex_iterator i = words_begin; i != words_end; ++i) {

                std::smatch token = *i;

                if (beginPosition == beginOffset) {
                    if (boost::iequals(token.str(), "EMPTY")) {
                        continue;   // Nothing more to do, this
                    }
                } else {
                    long nextPosition = token.position() + beginOffset;

                    std::string str(wkt.substr(beginPosition, nextPosition - beginPosition));
                    boost::algorithm::erase_last(str, ",");

                    geometryCollection.push_back(geometry(str));
                }
                beginPosition = token.position() + beginOffset;
            }
            if (beginPosition != beginOffset) {  // We had at least 1 so get the last
                std::string str(wkt.substr(beginPosition, endPosition - beginPosition));

                geometryCollection.push_back(geometry(str));
            }
        }
    } // namespace io

}   // namespace geofeatures

#endif //__ReadWKT_HPP_
