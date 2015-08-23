//
//! Copyright (c) 2011-2012
//! Brandon Kohn
//
//  Distributed under the Boost Software License, Version 1.0. (See
//  accompanying file LICENSE_1_0.txt or copy at
//  http://www.boost.org/LICENSE_1_0.txt)
//
namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace numeric {
    
    
    template <>
    struct numeric_cast_traits
        <
            char
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            char
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            signed char
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            signed char
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned char
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned char
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            short
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            short
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned short
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned short
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            int
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            int
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned int
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned int
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            long
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            long
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned long
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            unsigned long
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            float
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            float
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            double
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            double
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            long double
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            long double
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            geofeatures_boost::long_long_type
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            geofeatures_boost::long_long_type
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            geofeatures_boost::ulong_long_type
          , geofeatures_boost::long_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::long_long_type> rounding_policy;
    }; 
    
    template <>
    struct numeric_cast_traits
        <
            geofeatures_boost::ulong_long_type
          , geofeatures_boost::ulong_long_type
        >
    {
        typedef def_overflow_handler overflow_policy;
        typedef UseInternalRangeChecker range_checking_policy;
        typedef Trunc<geofeatures_boost::ulong_long_type> rounding_policy;
    }; 
}}
