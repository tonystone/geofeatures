// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2007-2012 Barend Gehrels, Amsterdam, the Netherlands.

// This file was modified by Oracle on 2013, 2014, 2015.
// Modifications copyright (c) 2013-2015 Oracle and/or its affiliates.

// Contributed and/or modified by Adam Wulkiewicz, on behalf of Oracle

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_UTIL_RANGE_HPP
#define BOOST_GEOMETRY_UTIL_RANGE_HPP

#include <algorithm>

#include <boost/concept_check.hpp>
#include <boost/config.hpp>
#include <boost/range/concepts.hpp>
#include <boost/range/begin.hpp>
#include <boost/range/end.hpp>
#include <boost/range/empty.hpp>
#include <boost/range/size.hpp>
#include <boost/type_traits/is_convertible.hpp>

#include <boost/geometry/core/assert.hpp>
#include <boost/geometry/core/mutable_range.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry { namespace range {

namespace detail {

// NOTE: For SinglePassRanges pos could iterate over all elements until the i-th element was met.

template <typename RandomAccessRange>
struct pos
{
    typedef typename geofeatures_boost::range_iterator<RandomAccessRange>::type iterator;
    typedef typename geofeatures_boost::range_size<RandomAccessRange>::type size_type;
    typedef typename geofeatures_boost::range_difference<RandomAccessRange>::type difference_type;

    static inline iterator apply(RandomAccessRange & rng, size_type i)
    {
        BOOST_RANGE_CONCEPT_ASSERT(( geofeatures_boost::RandomAccessRangeConcept<RandomAccessRange> ));
        return geofeatures_boost::begin(rng) + static_cast<difference_type>(i);
    }
};

} // namespace detail

/*!
\brief Short utility to conveniently return an iterator of a RandomAccessRange.
\ingroup utility
*/
template <typename RandomAccessRange>
inline typename geofeatures_boost::range_iterator<RandomAccessRange const>::type
pos(RandomAccessRange const& rng,
    typename geofeatures_boost::range_size<RandomAccessRange const>::type i)
{
    BOOST_GEOMETRY_ASSERT(i <= geofeatures_boost::size(rng));
    return detail::pos<RandomAccessRange const>::apply(rng, i);
}

/*!
\brief Short utility to conveniently return an iterator of a RandomAccessRange.
\ingroup utility
*/
template <typename RandomAccessRange>
inline typename geofeatures_boost::range_iterator<RandomAccessRange>::type
pos(RandomAccessRange & rng,
    typename geofeatures_boost::range_size<RandomAccessRange>::type i)
{
    BOOST_GEOMETRY_ASSERT(i <= geofeatures_boost::size(rng));
    return detail::pos<RandomAccessRange>::apply(rng, i);
}

/*!
\brief Short utility to conveniently return an element of a RandomAccessRange.
\ingroup utility
*/
template <typename RandomAccessRange>
inline typename geofeatures_boost::range_reference<RandomAccessRange const>::type
at(RandomAccessRange const& rng,
   typename geofeatures_boost::range_size<RandomAccessRange const>::type i)
{
    BOOST_GEOMETRY_ASSERT(i < geofeatures_boost::size(rng));
    return * detail::pos<RandomAccessRange const>::apply(rng, i);
}

/*!
\brief Short utility to conveniently return an element of a RandomAccessRange.
\ingroup utility
*/
template <typename RandomAccessRange>
inline typename geofeatures_boost::range_reference<RandomAccessRange>::type
at(RandomAccessRange & rng,
   typename geofeatures_boost::range_size<RandomAccessRange>::type i)
{
    BOOST_GEOMETRY_ASSERT(i < geofeatures_boost::size(rng));
    return * detail::pos<RandomAccessRange>::apply(rng, i);
}

/*!
\brief Short utility to conveniently return the front element of a Range.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_reference<Range const>::type
front(Range const& rng)
{
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    return *geofeatures_boost::begin(rng);
}

/*!
\brief Short utility to conveniently return the front element of a Range.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_reference<Range>::type
front(Range & rng)
{
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    return *geofeatures_boost::begin(rng);
}

// NOTE: For SinglePassRanges back() could iterate over all elements until the last element is met.

/*!
\brief Short utility to conveniently return the back element of a BidirectionalRange.
\ingroup utility
*/
template <typename BidirectionalRange>
inline typename geofeatures_boost::range_reference<BidirectionalRange const>::type
back(BidirectionalRange const& rng)
{
    BOOST_RANGE_CONCEPT_ASSERT(( geofeatures_boost::BidirectionalRangeConcept<BidirectionalRange const> ));
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    return *(geofeatures_boost::rbegin(rng));
}

/*!
\brief Short utility to conveniently return the back element of a BidirectionalRange.
\ingroup utility
*/
template <typename BidirectionalRange>
inline typename geofeatures_boost::range_reference<BidirectionalRange>::type
back(BidirectionalRange & rng)
{
    BOOST_RANGE_CONCEPT_ASSERT((geofeatures_boost::BidirectionalRangeConcept<BidirectionalRange>));
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    return *(geofeatures_boost::rbegin(rng));
}


/*!
\brief Short utility to conveniently clear a mutable range.
       It uses traits::clear<>.
\ingroup utility
*/
template <typename Range>
inline void clear(Range & rng)
{
    // NOTE: this trait is probably not needed since it could be implemented using resize()
    geometry::traits::clear<Range>::apply(rng);
}

/*!
\brief Short utility to conveniently insert a new element at the end of a mutable range.
       It uses geofeatures_boost::geometry::traits::push_back<>.
\ingroup utility
*/
template <typename Range>
inline void push_back(Range & rng,
                      typename geofeatures_boost::range_value<Range>::type const& value)
{
    geometry::traits::push_back<Range>::apply(rng, value);
}

/*!
\brief Short utility to conveniently resize a mutable range.
       It uses geofeatures_boost::geometry::traits::resize<>.
\ingroup utility
*/
template <typename Range>
inline void resize(Range & rng,
                   typename geofeatures_boost::range_size<Range>::type new_size)
{
    geometry::traits::resize<Range>::apply(rng, new_size);
}


/*!
\brief Short utility to conveniently remove an element from the back of a mutable range.
       It uses resize().
\ingroup utility
*/
template <typename Range>
inline void pop_back(Range & rng)
{
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    range::resize(rng, geofeatures_boost::size(rng) - 1);
}

namespace detail {

#ifndef BOOST_NO_CXX11_RVALUE_REFERENCES

template <typename It,
          typename OutIt,
          bool UseMove = geofeatures_boost::is_convertible
                            <
                                typename std::iterator_traits<It>::value_type &&,
                                typename std::iterator_traits<OutIt>::value_type
                            >::value>
struct copy_or_move_impl
{
    static inline OutIt apply(It first, It last, OutIt out)
    {
        return std::move(first, last, out);
    }
};

template <typename It, typename OutIt>
struct copy_or_move_impl<It, OutIt, false>
{
    static inline OutIt apply(It first, It last, OutIt out)
    {
        return std::copy(first, last, out);
    }
};

template <typename It, typename OutIt>
inline OutIt copy_or_move(It first, It last, OutIt out)
{
    return copy_or_move_impl<It, OutIt>::apply(first, last, out);
}

#else

template <typename It, typename OutIt>
inline OutIt copy_or_move(It first, It last, OutIt out)
{
    return std::copy(first, last, out);
}

#endif

} // namespace detail

/*!
\brief Short utility to conveniently remove an element from a mutable range.
       It uses std::copy() and resize(). Version taking mutable iterators.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_iterator<Range>::type
erase(Range & rng,
      typename geofeatures_boost::range_iterator<Range>::type it)
{
    BOOST_GEOMETRY_ASSERT(!geofeatures_boost::empty(rng));
    BOOST_GEOMETRY_ASSERT(it != geofeatures_boost::end(rng));

    typename geofeatures_boost::range_difference<Range>::type const
        d = std::distance(geofeatures_boost::begin(rng), it);

    typename geofeatures_boost::range_iterator<Range>::type
        next = it;
    ++next;

    detail::copy_or_move(next, geofeatures_boost::end(rng), it);
    range::resize(rng, geofeatures_boost::size(rng) - 1);

    // NOTE: In general this should be sufficient:
    //    return it;
    // But in MSVC using the returned iterator causes
    // assertion failures when iterator debugging is enabled
    // Furthermore the code below should work in the case if resize()
    // invalidates iterators when the container is resized down.
    return geofeatures_boost::begin(rng) + d;
}

/*!
\brief Short utility to conveniently remove an element from a mutable range.
       It uses std::copy() and resize(). Version taking non-mutable iterators.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_iterator<Range>::type
erase(Range & rng,
      typename geofeatures_boost::range_iterator<Range const>::type cit)
{
    BOOST_RANGE_CONCEPT_ASSERT(( geofeatures_boost::RandomAccessRangeConcept<Range> ));

    typename geofeatures_boost::range_iterator<Range>::type
        it = geofeatures_boost::begin(rng)
                + std::distance(geofeatures_boost::const_begin(rng), cit);

    return erase(rng, it);
}

/*!
\brief Short utility to conveniently remove a range of elements from a mutable range.
       It uses std::copy() and resize(). Version taking mutable iterators.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_iterator<Range>::type
erase(Range & rng,
      typename geofeatures_boost::range_iterator<Range>::type first,
      typename geofeatures_boost::range_iterator<Range>::type last)
{
    typename geofeatures_boost::range_difference<Range>::type const
        diff = std::distance(first, last);
    BOOST_GEOMETRY_ASSERT(diff >= 0);

    std::size_t const count = static_cast<std::size_t>(diff);
    BOOST_GEOMETRY_ASSERT(count <= geofeatures_boost::size(rng));
    
    if ( count > 0 )
    {
        typename geofeatures_boost::range_difference<Range>::type const
            d = std::distance(geofeatures_boost::begin(rng), first);

        detail::copy_or_move(last, geofeatures_boost::end(rng), first);
        range::resize(rng, geofeatures_boost::size(rng) - count);

        // NOTE: In general this should be sufficient:
        //    return first;
        // But in MSVC using the returned iterator causes
        // assertion failures when iterator debugging is enabled
        // Furthermore the code below should work in the case if resize()
        // invalidates iterators when the container is resized down.
        return geofeatures_boost::begin(rng) + d;
    }

    return first;
}

/*!
\brief Short utility to conveniently remove a range of elements from a mutable range.
       It uses std::copy() and resize(). Version taking non-mutable iterators.
\ingroup utility
*/
template <typename Range>
inline typename geofeatures_boost::range_iterator<Range>::type
erase(Range & rng,
      typename geofeatures_boost::range_iterator<Range const>::type cfirst,
      typename geofeatures_boost::range_iterator<Range const>::type clast)
{
    BOOST_RANGE_CONCEPT_ASSERT(( geofeatures_boost::RandomAccessRangeConcept<Range> ));

    typename geofeatures_boost::range_iterator<Range>::type
        first = geofeatures_boost::begin(rng)
                    + std::distance(geofeatures_boost::const_begin(rng), cfirst);
    typename geofeatures_boost::range_iterator<Range>::type
        last = geofeatures_boost::begin(rng)
                    + std::distance(geofeatures_boost::const_begin(rng), clast);

    return erase(rng, first, last);
}

}}} // namespace geofeatures_boost::geometry::range

#endif // BOOST_GEOMETRY_UTIL_RANGE_HPP
