// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2007-2012 Barend Gehrels, Amsterdam, the Netherlands.
// Copyright (c) 2013 Adam Wulkiewicz, Lodz, Poland

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_ALGORITHMS_DETAIL_OVERLAY_DO_REVERSE_HPP
#define BOOST_GEOMETRY_ALGORITHMS_DETAIL_OVERLAY_DO_REVERSE_HPP

#include <boost/geometry/core/point_order.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{


#ifndef DOXYGEN_NO_DETAIL
namespace detail { namespace overlay
{

// Metafunction helper for intersection and union
template <order_selector Selector, bool Reverse = false>
struct do_reverse {};

template <>
struct do_reverse<clockwise, false> : geofeatures_boost::false_type {};

template <>
struct do_reverse<clockwise, true> : geofeatures_boost::true_type {};

template <>
struct do_reverse<counterclockwise, false> : geofeatures_boost::true_type {};

template <>
struct do_reverse<counterclockwise, true> : geofeatures_boost::false_type {};


}} // namespace detail::overlay
#endif // DOXYGEN_NO_DETAIL


}} // namespace geofeatures_boost::geometry


#endif // BOOST_GEOMETRY_ALGORITHMS_DETAIL_OVERLAY_DO_REVERSE_HPP
