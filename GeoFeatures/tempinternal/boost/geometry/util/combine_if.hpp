// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2014-2015 Samuel Debionne, Grenoble, France.

// This file was modified by Oracle on 2015.
// Modifications copyright (c) 2015, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Parts of Boost.Geometry are redesigned from Geodan's Geographic Library
// (geolib/GGL), copyright (c) 1995-2010 Geodan, Amsterdam, the Netherlands.

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_UTIL_COMBINE_IF_HPP
#define BOOST_GEOMETRY_UTIL_COMBINE_IF_HPP

#include <boost/mpl/fold.hpp>
#include <boost/mpl/if.hpp>
#include <boost/mpl/bind.hpp>
#include <boost/mpl/set.hpp>
#include <boost/mpl/insert.hpp>
#include <boost/mpl/placeholders.hpp>

#include <boost/type_traits.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{

namespace util
{


/*!
    \brief Meta-function to generate all the combination of pairs of types
        from a given sequence Sequence except those that does not satisfy the
        predicate Pred
    \ingroup utility
    \par Example
    \code
        typedef geofeatures_boost::mpl::vector<geofeatures_boost::mpl::int_<0>, geofeatures_boost::mpl::int_<1> > types;
        typedef combine_if<types, types, always<true_> >::type combinations;
        typedef geofeatures_boost::mpl::vector<
            pair<geofeatures_boost::mpl::int_<1>, geofeatures_boost::mpl::int_<1> >,
            pair<geofeatures_boost::mpl::int_<1>, geofeatures_boost::mpl::int_<0> >,
            pair<geofeatures_boost::mpl::int_<0>, geofeatures_boost::mpl::int_<1> >,
            pair<geofeatures_boost::mpl::int_<0>, geofeatures_boost::mpl::int_<0> >        
        > result_types;
        
        BOOST_MPL_ASSERT(( geofeatures_boost::mpl::equal<combinations, result_types> ));
    \endcode
*/
template <typename Sequence1, typename Sequence2, typename Pred>
struct combine_if
{
    struct combine
    {
        template <typename Result, typename T>
        struct apply
        {
            typedef typename geofeatures_boost::mpl::fold<Sequence2, Result,
                geofeatures_boost::mpl::if_
                <
                    geofeatures_boost::mpl::bind
                        <
                            typename geofeatures_boost::mpl::lambda<Pred>::type,
                            T,
                            geofeatures_boost::mpl::_2
                        >,
                    geofeatures_boost::mpl::insert
                        <
                            geofeatures_boost::mpl::_1, geofeatures_boost::mpl::pair<T, geofeatures_boost::mpl::_2>
                        >,
                    geofeatures_boost::mpl::_1
                >
            >::type type;
        };
    };

    typedef typename geofeatures_boost::mpl::fold
        <
            Sequence1, geofeatures_boost::mpl::set0<>, combine
        >::type type;
};


} // namespace util

}} // namespace geofeatures_boost::geometry

#endif // BOOST_GEOMETRY_UTIL_COMBINE_IF_HPP
