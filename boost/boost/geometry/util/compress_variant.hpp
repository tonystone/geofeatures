// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2007-2015 Barend Gehrels, Amsterdam, the Netherlands.
// Copyright (c) 2008-2015 Bruno Lalande, Paris, France.
// Copyright (c) 2009-2015 Mateusz Loskot, London, UK.

// This file was modified by Oracle on 2015.
// Modifications copyright (c) 2015, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Parts of Boost.Geometry are redesigned from Geodan's Geographic Library
// (geolib/GGL), copyright (c) 1995-2010 Geodan, Amsterdam, the Netherlands.

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_UTIL_COMPRESS_VARIANT_HPP
#define BOOST_GEOMETRY_UTIL_COMPRESS_VARIANT_HPP


#include <boost/mpl/equal_to.hpp>
#include <boost/mpl/fold.hpp>
#include <boost/mpl/front.hpp>
#include <boost/mpl/if.hpp>
#include <boost/mpl/insert.hpp>
#include <boost/mpl/int.hpp>
#include <boost/mpl/set.hpp>
#include <boost/mpl/size.hpp>
#include <boost/mpl/vector.hpp>
#include <boost/variant/variant_fwd.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{


namespace detail
{

template <typename Variant>
struct unique_types:
    geofeatures_boost::mpl::fold<
        typename geofeatures_boost::mpl::reverse_fold<
            typename Variant::types,
            geofeatures_boost::mpl::set<>,
            geofeatures_boost::mpl::insert<
                geofeatures_boost::mpl::placeholders::_1,
                geofeatures_boost::mpl::placeholders::_2
            >
        >::type,
        geofeatures_boost::mpl::vector<>,
        geofeatures_boost::mpl::push_back
            <
                geofeatures_boost::mpl::placeholders::_1, geofeatures_boost::mpl::placeholders::_2
            >
    >
{};

template <typename Types>
struct variant_or_single:
    geofeatures_boost::mpl::if_<
        geofeatures_boost::mpl::equal_to<
            geofeatures_boost::mpl::size<Types>,
            geofeatures_boost::mpl::int_<1>
        >,
        typename geofeatures_boost::mpl::front<Types>::type,
        typename make_variant_over<Types>::type
    >
{};

} // namespace detail


/*!
    \brief Meta-function that takes a geofeatures_boost::variant type and tries to minimize
        it by doing the following:
        - if there's any duplicate types, remove them
        - if the result is a variant of one type, turn it into just that type
    \ingroup utility
    \par Example
    \code
        typedef variant<int, float, int, long> variant_type;
        typedef compress_variant<variant_type>::type compressed;
        typedef geofeatures_boost::mpl::vector<int, float, long> result_types;
        BOOST_MPL_ASSERT(( geofeatures_boost::mpl::equal<compressed::types, result_types> ));

        typedef variant<int, int, int> one_type_variant_type;
        typedef compress_variant<one_type_variant_type>::type single_type;
        BOOST_MPL_ASSERT(( geofeatures_boost::equals<single_type, int> ));
    \endcode
*/

template <typename Variant>
struct compress_variant:
    detail::variant_or_single<
        typename detail::unique_types<Variant>::type
    >
{};


}} // namespace geofeatures_boost::geometry


#endif // BOOST_GEOMETRY_UTIL_COMPRESS_VARIANT_HPP
