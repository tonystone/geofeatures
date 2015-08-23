// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2008-2012 Bruno Lalande, Paris, France.
// Copyright (c) 2007-2012 Barend Gehrels, Amsterdam, the Netherlands.
// Copyright (c) 2009-2012 Mateusz Loskot, London, UK.

// Parts of Boost.Geometry are redesigned from Geodan's Geographic Library
// (geolib/GGL), copyright (c) 1995-2010 Geodan, Amsterdam, the Netherlands.

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_GEOMETRIES_VARIANT_GEOMETRY_HPP
#define BOOST_GEOMETRY_GEOMETRIES_VARIANT_GEOMETRY_HPP


#include <boost/variant/variant_fwd.hpp>
#include <boost/mpl/front.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry {


template <BOOST_VARIANT_ENUM_PARAMS(typename T)>
struct point_type<geofeatures_boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)> >
    : point_type<
        typename geofeatures_boost::mpl::front<
            typename geofeatures_boost::variant<BOOST_VARIANT_ENUM_PARAMS(T)>::types
        >::type
    >
{};


} // namespace geometry
} // namespace geofeatures_boost


#endif // BOOST_GEOMETRY_GEOMETRIES_VARIANT_GEOMETRY_HPP
