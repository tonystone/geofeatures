// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2015, Oracle and/or its affiliates.

// Contributed and/or modified by Menelaos Karavelas, on behalf of Oracle

// Licensed under the Boost Software License version 1.0.
// http://www.boost.org/users/license.html

#ifndef BOOST_GEOMETRY_UTIL_PROMOTE_INTEGRAL_HPP
#define BOOST_GEOMETRY_UTIL_PROMOTE_INTEGRAL_HPP

// For now deactivate the use of multiprecision integers
// TODO: activate it later
#define BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER

#include <climits>
#include <cstddef>

#include <boost/mpl/begin.hpp>
#include <boost/mpl/deref.hpp>
#include <boost/mpl/end.hpp>
#include <boost/mpl/if.hpp>
#include <boost/mpl/list.hpp>
#include <boost/mpl/next.hpp>
#include <boost/mpl/size_t.hpp>

#if !defined(BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER)
#include <boost/multiprecision/cpp_int.hpp>
#endif

#include <boost/type_traits/integral_constant.hpp>
#include <boost/type_traits/is_fundamental.hpp>
#include <boost/type_traits/is_integral.hpp>
#include <boost/type_traits/is_unsigned.hpp>


namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{

#ifndef DOXYGEN_NO_DETAIL
namespace detail { namespace promote_integral
{

// meta-function that returns the bit size of a type
template
<
    typename T,
    bool IsFundamental = geofeatures_boost::is_fundamental<T>::type::value
>
struct bit_size
{};


// for fundamental types, just return CHAR_BIT * sizeof(T)
template <typename T>
struct bit_size<T, true>
    : geofeatures_boost::mpl::size_t<(CHAR_BIT * sizeof(T))>
{};


#if !defined(BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER)
// partial specialization for cpp_int
template
<
    unsigned MinSize,
    unsigned MaxSize,
    geofeatures_boost::multiprecision::cpp_integer_type SignType,
    geofeatures_boost::multiprecision::cpp_int_check_type Checked,
    typename Allocator,
    geofeatures_boost::multiprecision::expression_template_option ExpressionTemplates
>
struct bit_size
    <
        geofeatures_boost::multiprecision::number
            <
                geofeatures_boost::multiprecision::cpp_int_backend
                    <
                        MinSize, MaxSize, SignType, Checked, Allocator
                    >,
                ExpressionTemplates
            >,
        false
    > : geofeatures_boost::mpl::size_t<MaxSize>
{};
#endif // BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER


template
<
    typename T,
    typename Iterator,
    typename EndIterator,
    std::size_t MinSize
>
struct promote_to_larger
{
    typedef typename geofeatures_boost::mpl::deref<Iterator>::type current_type;

    typedef typename geofeatures_boost::mpl::if_c
        <
            (bit_size<current_type>::type::value >= MinSize),
            current_type,
            typename promote_to_larger
                <
                    T,
                    typename geofeatures_boost::mpl::next<Iterator>::type,
                    EndIterator,
                    MinSize
                >::type
        >::type type;
};

// The following specialization is required to finish the loop over
// all list elements
template <typename T, typename EndIterator, std::size_t MinSize>
struct promote_to_larger<T, EndIterator, EndIterator, MinSize>
{
    // if promotion fails, keep the number T
    // (and cross fingers that overflow will not occur)
    typedef T type;
};

}} // namespace detail::promote_integral
#endif // DOXYGEN_NO_DETAIL



/*!
    \brief Meta-function to define an integral type with size
    than is (roughly) twice the bit size of T
    \ingroup utility
    \details
    This meta-function tries to promote the fundamental integral type T
    to a another integral type with size (roughly) twice the bit size of T.

    To do this, two times the bit size of T is tested against the bit sizes of:
         short, int, long, geofeatures_boost::long_long_type, geofeatures_boost::int128_t
    and the one that first matches is chosen.

    For unsigned types the bit size of T is tested against the bit
    sizes of the types above, if T is promoted to a signed type, or
    the bit sizes of
         unsigned short, unsigned int, unsigned long, std::size_t,
         geofeatures_boost::ulong_long_type, geofeatures_boost::uint128_t
    if T is promoted to an unsigned type.

    By default an unsigned type is promoted to a signed type.
    This behavior is controlled by the PromoteUnsignedToUnsigned
    boolean template parameter, whose default value is "false".
    To promote an unsigned type to an unsigned type set the value of
    this template parameter to "true".

    If the macro BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER is not
    defined, boost's multiprecision integer cpp_int<> is used as a
    last resort.

    If BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER is defined and an
    appropriate type cannot be detected, the input type is returned as is.

    Finally, if the passed type is either a floating-point type or a
    user-defined type it is returned as is.

    \note geofeatures_boost::long_long_type and geofeatures_boost::ulong_long_type are
    considered only if the macro BOOST_HAS_LONG_LONG is defined

    \note geofeatures_boost::int128_type and geofeatures_boost::uint128_type are considered
    only if the macros BOOST_HAS_INT128 and BOOST_GEOMETRY_ENABLE_INT128
    are defined
*/
template
<
    typename T,
    bool PromoteUnsignedToUnsigned = false,
    bool UseCheckedInteger = false,
    bool IsIntegral = geofeatures_boost::is_integral<T>::type::value
>
class promote_integral
{
private:
    static bool const is_unsigned = geofeatures_boost::is_unsigned<T>::type::value;

    typedef detail::promote_integral::bit_size<T> bit_size_type;

#if !defined(BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER)
    // Define the proper check policy for the multiprecision integer
    typedef typename geofeatures_boost::mpl::if_c
        <
            UseCheckedInteger,
            geofeatures_boost::integral_constant
                <
                    geofeatures_boost::multiprecision::cpp_int_check_type,
                    geofeatures_boost::multiprecision::checked
                >,
            geofeatures_boost::integral_constant
                <
                    geofeatures_boost::multiprecision::cpp_int_check_type,
                    geofeatures_boost::multiprecision::unchecked
                >
        >::type check_policy_type;

    // Meta-function to get the multiprecision integer type for the
    // given size and sign type (signed/unsigned)
    template
    <
        unsigned int Size,
        geofeatures_boost::multiprecision::cpp_integer_type SignType
    >
    struct multiprecision_integer_type
    {
        typedef geofeatures_boost::multiprecision::number
            <
                geofeatures_boost::multiprecision::cpp_int_backend
                    <
                        Size,
                        Size,
                        SignType,
                        check_policy_type::value,
                        void
                    >
            > type;
    };
#endif

    // Define the minimum size (in bits) needed for the promoted type
    // If T is the input type and P the promoted type, then the
    // minimum number of bits for P are (below b stands for the number
    // of bits of T):
    // * if T is unsigned and P is unsigned: 2 * b
    // * if T is signed and P is signed: 2 * b - 1
    // * if T is unsigned and P is signed: 2 * b + 1
    typedef typename geofeatures_boost::mpl::if_c
        <
            (PromoteUnsignedToUnsigned && is_unsigned),
            geofeatures_boost::mpl::size_t<(2 * bit_size_type::value)>,
            typename geofeatures_boost::mpl::if_c
                <
                    is_unsigned,
                    geofeatures_boost::mpl::size_t<(2 * bit_size_type::value + 1)>,
                    geofeatures_boost::mpl::size_t<(2 * bit_size_type::value - 1)>
                >::type
        >::type min_bit_size_type;

    // Define the list of signed integral types we are going to use
    // for promotion
    typedef geofeatures_boost::mpl::list
        <
            short, int, long
#if defined(BOOST_HAS_LONG_LONG)
            , geofeatures_boost::long_long_type
#endif
#if defined(BOOST_HAS_INT128) && defined(BOOST_GEOMETRY_ENABLE_INT128)
            , geofeatures_boost::int128_type
#endif
#if !defined(BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER)
            , typename multiprecision_integer_type
                <
                    min_bit_size_type::value,
                    geofeatures_boost::multiprecision::signed_magnitude
                >::type
#endif
        > signed_integral_types;

    // Define the list of unsigned integral types we are going to use
    // for promotion
    typedef geofeatures_boost::mpl::list
        <
            unsigned short, unsigned int, unsigned long, std::size_t
#if defined(BOOST_HAS_LONG_LONG)
            , geofeatures_boost::ulong_long_type
#endif
#if defined(BOOST_HAS_INT128) && defined(BOOST_GEOMETRY_ENABLE_INT128)
            , geofeatures_boost::uint128_type
#endif
#if !defined(BOOST_GEOMETRY_NO_MULTIPRECISION_INTEGER)
            , typename multiprecision_integer_type
                <
                    min_bit_size_type::value,
                    geofeatures_boost::multiprecision::unsigned_magnitude
                >::type
#endif
        > unsigned_integral_types;

    // Define the list of integral types that will be used for
    // promotion (depending in whether we was to promote unsigned to
    // unsigned or not)
    typedef typename geofeatures_boost::mpl::if_c
        <
            (is_unsigned && PromoteUnsignedToUnsigned),
            unsigned_integral_types,
            signed_integral_types
        >::type integral_types;

public:
    typedef typename detail::promote_integral::promote_to_larger
        <
            T,
            typename geofeatures_boost::mpl::begin<integral_types>::type,
            typename geofeatures_boost::mpl::end<integral_types>::type,
            min_bit_size_type::value
        >::type type;
};


template <typename T, bool PromoteUnsignedToUnsigned, bool UseCheckedInteger>
class promote_integral
    <
        T, PromoteUnsignedToUnsigned, UseCheckedInteger, false
    >
{
public:
    typedef T type;
};


}} // namespace geofeatures_boost::geometry

#endif // BOOST_GEOMETRY_UTIL_PROMOTE_INTEGRAL_HPP
