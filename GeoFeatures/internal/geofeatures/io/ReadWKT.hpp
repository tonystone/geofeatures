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
            static std::string GeometryCollectionToken = "GEOMETRYCOLLECTION";
            static std::regex tokensRegex("\\b(POINT|MULTIPOINT|LINESTRING|MULTILINESTRING|POLYGON|MULTIPOLYGON)", std::regex_constants::icase);
            static std::regex emptyTokenRegex("[ \\t]*EMPTY[ \\t]*", std::regex_constants::icase);
            
            if (!boost::istarts_with(wkt, GeometryCollectionToken)) {
                throw std::invalid_argument("Should start with 'GEOMETRYCOLLECTION'' in (" + wkt + ")");
            }
       
            long tokensBegin = wkt.find_first_of("(");
            long tokensEnd = wkt.find_last_of(")");
            
            bool openClosePerensFound = (tokensBegin != std::string::npos) && (tokensEnd != std::string::npos);
            
            if (tokensBegin != std::string::npos)
                tokensBegin += 1;
            else
                tokensBegin = GeometryCollectionToken.length();

            if (tokensEnd != std::string::npos)
               tokensEnd -= 1;
            else
                tokensEnd = wkt.length();
            
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

            auto matchesBegin = std::sregex_iterator(wkt.begin(), wkt.end(), tokensRegex);
            auto matchesEnd = std::sregex_iterator();

            if (std::distance(matchesBegin, matchesEnd) > 0) {
                
                std::sregex_iterator i = matchesBegin;
                
                std::smatch match = *i;
                
                long currentToken = match.position();

                i++;
                
                for (; i != matchesEnd; i++) {
                    
                    std::smatch match = *i;
                    long nextToken = match.position();

                    std::string str(wkt.substr(currentToken, nextToken - currentToken));
                    boost::algorithm::erase_last(str, ",");
                    
                    geometryCollection.push_back(geometry(str));
                    
                    currentToken = nextToken;
                }
                std::string str(wkt.substr(currentToken, tokensEnd - currentToken + 1));
                
                geometryCollection.push_back(geometry(str));

            } else {
                if (!openClosePerensFound) {
                
                    auto str = wkt.substr(tokensBegin, tokensEnd - tokensBegin + 1);
                    
                    auto matches = std::sregex_iterator(str.begin(), str.end(), emptyTokenRegex);
                    if (std::distance(matches, std::sregex_iterator()) != 1) {
                        throw std::invalid_argument("Invalid wkt, expected EMPTY but got " + str);
                    }
                }
            }
        }
    } // namespace io

}   // namespace geofeatures

#endif //__ReadWKT_HPP_
