
//  (C) Copyright Steve Cleary, Beman Dawes, Howard Hinnant & John Maddock 2000.
//  Use, modification and distribution are subject to the Boost Software License,
//  Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
//  http://www.boost.org/LICENSE_1_0.txt).
//
//  See http://www.boost.org/libs/type_traits for most recent version including documentation.

#ifndef BOOST_TT_IS_OBJECT_HPP_INCLUDED
#define BOOST_TT_IS_OBJECT_HPP_INCLUDED

#include <boost/type_traits/is_reference.hpp>
#include <boost/type_traits/is_void.hpp>
#include <boost/type_traits/is_function.hpp>
#include <boost/type_traits/detail/ice_and.hpp>
#include <boost/type_traits/detail/ice_not.hpp>
#include <boost/config.hpp>

// should be the last #include
#include <boost/type_traits/detail/bool_trait_def.hpp>

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {

namespace detail {

template <typename T>
struct is_object_impl
{
   BOOST_STATIC_CONSTANT(bool, value =
      (::geofeatures_boost::type_traits::ice_and<
         ::geofeatures_boost::type_traits::ice_not< ::geofeatures_boost::is_reference<T>::value>::value,
         ::geofeatures_boost::type_traits::ice_not< ::geofeatures_boost::is_void<T>::value>::value,
         ::geofeatures_boost::type_traits::ice_not< ::geofeatures_boost::is_function<T>::value>::value
      >::value));
};

} // namespace detail

BOOST_TT_AUX_BOOL_TRAIT_DEF1(is_object,T,::geofeatures_boost::detail::is_object_impl<T>::value)

} // namespace geofeatures_boost

#include <boost/type_traits/detail/bool_trait_undef.hpp>

#endif // BOOST_TT_IS_OBJECT_HPP_INCLUDED
