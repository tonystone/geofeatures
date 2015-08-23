// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2014, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Licensed under the Boost Software License version 1.0.
// http://www.boost.org/users/license.html

#ifndef BOOST_GEOMETRY_ALGORITHMS_DETAIL_NUM_DISTINCT_CONSECUTIVE_POINTS_HPP
#define BOOST_GEOMETRY_ALGORITHMS_DETAIL_NUM_DISTINCT_CONSECUTIVE_POINTS_HPP

#include <cstddef>

#include <algorithm>

#include <boost/range.hpp>



namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{


#ifndef DOXYGEN_NO_DETAIL
namespace detail
{


// returns the number of distinct values in the range;
// return values are 0u through MaximumNumber, where MaximumNumber
// corresponds to MaximumNumber or more distinct values
//
// FUTURE: take into account topologically closed ranges;
//         add appropriate template parameter(s) to control whether
//         the closing point for topologically closed ranges is to be
//         accounted for separately or not
template
<
    typename Range,
    std::size_t MaximumNumber,
    bool AllowDuplicates /* true */,
    typename NotEqualTo
>
struct num_distinct_consecutive_points
{
    static inline std::size_t apply(Range const& range)
    {
        typedef typename geofeatures_boost::range_iterator<Range const>::type iterator;

        std::size_t const size = geofeatures_boost::size(range);

        if ( size < 2u )
        {
            return (size < MaximumNumber) ? size : MaximumNumber;
        }

        iterator current = geofeatures_boost::begin(range);
        std::size_t counter(0);
        do
        {
            ++counter;
            iterator next = std::find_if(current,
                                         geofeatures_boost::end(range),
                                         NotEqualTo(*current));
            current = next;
        }
        while ( current != geofeatures_boost::end(range) && counter <= MaximumNumber );

        return counter;
    }
};


template <typename Range, std::size_t MaximumNumber, typename NotEqualTo>
struct num_distinct_consecutive_points<Range, MaximumNumber, false, NotEqualTo>
{
    static inline std::size_t apply(Range const& range)
    {
        std::size_t const size = geofeatures_boost::size(range);
        return (size < MaximumNumber) ? size : MaximumNumber;
    }
};


} // namespace detail
#endif // DOXYGEN_NO_DETAIL


}} // namespace geofeatures_boost::geometry


#endif // BOOST_GEOMETRY_ALGORITHMS_DETAIL_NUM_DISTINCT_CONSECUTIVE_POINTS_HPP
