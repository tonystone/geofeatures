//  (C) Copyright 2009-2011 Frederic Bron.
//
//  Use, modification and distribution are subject to the Boost Software License,
//  Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
//  http://www.boost.org/LICENSE_1_0.txt).
//
//  See http://www.boost.org/libs/type_traits for most recent version including documentation.

#ifndef BOOST_TT_HAS_MINUS_ASSIGN_HPP_INCLUDED
#define BOOST_TT_HAS_MINUS_ASSIGN_HPP_INCLUDED

#define BOOST_TT_TRAIT_NAME has_minus_assign
#define BOOST_TT_TRAIT_OP -=
#define BOOST_TT_FORBIDDEN_IF\
   ::geofeatures_boost::type_traits::ice_or<\
      /* Lhs==pointer and Rhs==fundamental and Rhs!=integral */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::is_pointer< Lhs_noref >::value,\
         ::geofeatures_boost::is_fundamental< Rhs_nocv >::value,\
         ::geofeatures_boost::type_traits::ice_not< ::geofeatures_boost::is_integral< Rhs_noref >::value >::value\
      >::value,\
      /* Lhs==void* and Rhs==fundamental */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::is_pointer< Lhs_noref >::value,\
         ::geofeatures_boost::is_void< Lhs_noptr >::value,\
         ::geofeatures_boost::is_fundamental< Rhs_nocv >::value\
      >::value,\
      /* Rhs==void* and Lhs==fundamental */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::is_pointer< Rhs_noref >::value,\
         ::geofeatures_boost::is_void< Rhs_noptr >::value,\
         ::geofeatures_boost::is_fundamental< Lhs_nocv >::value\
      >::value,\
      /* Lhs=fundamental and Rhs=pointer */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::is_fundamental< Lhs_nocv >::value,\
         ::geofeatures_boost::is_pointer< Rhs_noref >::value\
      >::value,\
      /* Lhs==pointer and Rhs==pointer */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::is_pointer< Lhs_noref >::value,\
         ::geofeatures_boost::is_pointer< Rhs_noref >::value\
      >::value,\
      /* (Lhs==fundamental or Lhs==pointer) and (Rhs==fundamental or Rhs==pointer) and (Lhs==const) */\
      ::geofeatures_boost::type_traits::ice_and<\
         ::geofeatures_boost::type_traits::ice_or<\
            ::geofeatures_boost::is_fundamental< Lhs_nocv >::value,\
            ::geofeatures_boost::is_pointer< Lhs_noref >::value\
         >::value,\
         ::geofeatures_boost::type_traits::ice_or<\
            ::geofeatures_boost::is_fundamental< Rhs_nocv >::value,\
            ::geofeatures_boost::is_pointer< Rhs_noref >::value\
         >::value,\
         ::geofeatures_boost::is_const< Lhs_noref >::value\
      >::value\
   >::value


#include <boost/type_traits/detail/has_binary_operator.hpp>

#undef BOOST_TT_TRAIT_NAME
#undef BOOST_TT_TRAIT_OP
#undef BOOST_TT_FORBIDDEN_IF

#endif
