/**
*   GeometryVariant.hpp
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

#ifndef __GeometryVariant_HPP_
#define __GeometryVariant_HPP_

#include <boost/variant.hpp>
#include <boost/variant/polymorphic_get.hpp>

#include "Point.hpp"
#include "MultiPoint.hpp"
#include "LineString.hpp"
#include "MultiLineString.hpp"
#include "Ring.hpp"
#include "Polygon.hpp"
#include "MultiPolygon.hpp"
#include "GeometryCollection.hpp"
#include "Box.hpp"

namespace geofeatures {

    typedef boost::variant<
                geofeatures::Point,
                geofeatures::MultiPoint,
                geofeatures::Box,
                geofeatures::LineString,
                geofeatures::MultiLineString,
                geofeatures::Ring,
                geofeatures::Polygon,
                geofeatures::MultiPolygon,
                geofeatures::GeometryCollection<>>  GeometryVariant;

    typedef boost::variant<
                const geofeatures::Point *,
                const geofeatures::MultiPoint *,
                const geofeatures::Box *,
                const geofeatures::LineString *,
                const geofeatures::MultiLineString *,
                const geofeatures::Ring *,
                const geofeatures::Polygon *,
                const geofeatures::MultiPolygon *,
                const geofeatures::GeometryCollection<> *>  GeometryPtrVariant;

}   // namespace geofeatures

#endif //__GeometryVariant_HPP_
