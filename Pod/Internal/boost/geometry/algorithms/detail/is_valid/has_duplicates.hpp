// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2014-2015, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Licensed under the Boost Software License version 1.0.
// http://www.boost.org/users/license.html

#ifndef BOOST_GEOMETRY_ALGORITHMS_DETAIL_IS_VALID_HAS_DUPLICATES_HPP
#define BOOST_GEOMETRY_ALGORITHMS_DETAIL_IS_VALID_HAS_DUPLICATES_HPP

#include <boost/core/ignore_unused.hpp>
#include <boost/range.hpp>

#include <boost/geometry/core/closure.hpp>

#include <boost/geometry/policies/compare.hpp>
#include <boost/geometry/policies/is_valid/default_policy.hpp>

#include <boost/geometry/views/closeable_view.hpp>
#include <boost/geometry/algorithms/validity_failure_type.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{


#ifndef DOXYGEN_NO_DETAIL
namespace detail { namespace is_valid
{

template <typename Range, closure_selector Closure>
struct has_duplicates
{
    template <typename VisitPolicy>
    static inline bool apply(Range const& range, VisitPolicy& visitor)
    {
        geofeatures_boost::ignore_unused(visitor);

        typedef typename closeable_view<Range const, Closure>::type view_type;
        typedef typename geofeatures_boost::range_const_iterator
            <
                view_type const
            >::type const_iterator;

        view_type view(range);

        if ( geofeatures_boost::size(view) < 2 )
        {
            return ! visitor.template apply<no_failure>();
        }

        geometry::equal_to<typename geofeatures_boost::range_value<Range>::type> equal;

        const_iterator it = geofeatures_boost::const_begin(view);
        const_iterator next = it;
        ++next;
        for (; next != geofeatures_boost::const_end(view); ++it, ++next)
        {
            if ( equal(*it, *next) )
            {
                return ! visitor.template apply<failure_duplicate_points>(*it);
            }
        }
        return ! visitor.template apply<no_failure>();
    }
};



}} // namespace detail::is_valid
#endif // DOXYGEN_NO_DETAIL


}} // namespace geofeatures_boost::geometry



#endif // BOOST_GEOMETRY_ALGORITHMS_DETAIL_IS_VALID_HAS_DUPLICATES_HPP
