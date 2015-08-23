// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2007-2012 Barend Gehrels, Amsterdam, the Netherlands.
// Copyright (c) 2008-2012 Bruno Lalande, Paris, France.
// Copyright (c) 2009-2012 Mateusz Loskot, London, UK.

// Parts of Boost.Geometry are redesigned from Geodan's Geographic Library
// (geolib/GGL), copyright (c) 1995-2010 Geodan, Amsterdam, the Netherlands.

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_ITERATORS_BASE_HPP
#define BOOST_GEOMETRY_ITERATORS_BASE_HPP

#include <boost/iterator.hpp>
#include <boost/iterator/iterator_adaptor.hpp>
#include <boost/iterator/iterator_categories.hpp>
#include <boost/mpl/if.hpp>

#ifndef DOXYGEN_NO_DETAIL
namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry { namespace detail { namespace iterators
{

template
<
    typename DerivedClass,
    typename Iterator,
    typename TraversalFlag = geofeatures_boost::bidirectional_traversal_tag
>
struct iterator_base
    : public geofeatures_boost::iterator_adaptor
    <
        DerivedClass,
        Iterator,
        geofeatures_boost::use_default,
        typename geofeatures_boost::mpl::if_
        <
            geofeatures_boost::is_convertible
            <
                typename geofeatures_boost::iterator_traversal<Iterator>::type,
                geofeatures_boost::random_access_traversal_tag
            >,
            TraversalFlag,
            geofeatures_boost::use_default
        >::type
    >
{
    // Define operator cast to Iterator to be able to write things like Iterator it = myit++
    inline operator Iterator() const
    {
        return this->base();
    }

    /*inline bool operator==(Iterator const& other) const
    {
        return this->base() == other;
    }
    inline bool operator!=(Iterator const& other) const
    {
        return ! operator==(other);
    }*/
};

}}}} // namespace geofeatures_boost::geometry::detail::iterators
#endif


#endif // BOOST_GEOMETRY_ITERATORS_BASE_HPP
