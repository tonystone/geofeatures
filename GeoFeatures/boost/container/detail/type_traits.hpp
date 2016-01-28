//////////////////////////////////////////////////////////////////////////////
// (C) Copyright John Maddock 2000.
// (C) Copyright Ion Gaztanaga 2005-2015.
//
// Distributed under the Boost Software License, Version 1.0.
// (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)
//
// See http://www.boost.org/libs/container for documentation.
//
// The alignment and Type traits implementation comes from
// John Maddock's TypeTraits library.
//
// Some other tricks come from Howard Hinnant's papers and StackOverflow replies
//////////////////////////////////////////////////////////////////////////////
#ifndef BOOST_CONTAINER_CONTAINER_DETAIL_TYPE_TRAITS_HPP
#define BOOST_CONTAINER_CONTAINER_DETAIL_TYPE_TRAITS_HPP

#ifndef BOOST_CONFIG_HPP
#  include <boost/config.hpp>
#endif

#if defined(BOOST_HAS_PRAGMA_ONCE)
#  pragma once
#endif

#include <boost/move/detail/type_traits.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {
namespace container {
namespace container_detail {

using ::geofeatures_boost::move_detail::is_same;
using ::geofeatures_boost::move_detail::is_different;
using ::geofeatures_boost::move_detail::is_pointer;
using ::geofeatures_boost::move_detail::add_reference;
using ::geofeatures_boost::move_detail::add_const;
using ::geofeatures_boost::move_detail::add_const_reference;
using ::geofeatures_boost::move_detail::remove_const;
using ::geofeatures_boost::move_detail::remove_reference;
using ::geofeatures_boost::move_detail::make_unsigned;
using ::geofeatures_boost::move_detail::is_floating_point;
using ::geofeatures_boost::move_detail::is_integral;
using ::geofeatures_boost::move_detail::is_enum;
using ::geofeatures_boost::move_detail::is_pod;
using ::geofeatures_boost::move_detail::is_empty;
using ::geofeatures_boost::move_detail::is_trivially_destructible;
using ::geofeatures_boost::move_detail::is_trivially_default_constructible;
using ::geofeatures_boost::move_detail::is_trivially_copy_constructible;
using ::geofeatures_boost::move_detail::is_trivially_move_constructible;
using ::geofeatures_boost::move_detail::is_trivially_copy_assignable;
using ::geofeatures_boost::move_detail::is_trivially_move_assignable;
using ::geofeatures_boost::move_detail::is_nothrow_default_constructible;
using ::geofeatures_boost::move_detail::is_nothrow_copy_constructible;
using ::geofeatures_boost::move_detail::is_nothrow_move_constructible;
using ::geofeatures_boost::move_detail::is_nothrow_copy_assignable;
using ::geofeatures_boost::move_detail::is_nothrow_move_assignable;
using ::geofeatures_boost::move_detail::is_nothrow_swappable;
using ::geofeatures_boost::move_detail::alignment_of;
using ::geofeatures_boost::move_detail::aligned_storage;
using ::geofeatures_boost::move_detail::nat;
using ::geofeatures_boost::move_detail::max_align_t;

}  //namespace container_detail {
}  //namespace container {
}  //namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {

#endif   //#ifndef BOOST_CONTAINER_CONTAINER_DETAIL_TYPE_TRAITS_HPP
