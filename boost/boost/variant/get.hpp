//-----------------------------------------------------------------------------
// boost variant/get.hpp header file
// See http://www.boost.org for updates, documentation, and revision history.
//-----------------------------------------------------------------------------
//
// Copyright (c) 2003 Eric Friedman, Itay Maman
// Copyright (c) 2014 Antony Polukhin
//
// Distributed under the Boost Software License, Version 1.0. (See
// accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_VARIANT_GET_HPP
#define BOOST_VARIANT_GET_HPP

#include <exception>

#include "boost/config.hpp"
#include "boost/detail/workaround.hpp"
#include "boost/static_assert.hpp"
#include "boost/throw_exception.hpp"
#include "boost/utility/addressof.hpp"
#include "boost/variant/variant_fwd.hpp"
#include "boost/variant/detail/element_index.hpp"

#include "boost/type_traits/add_reference.hpp"
#include "boost/type_traits/add_pointer.hpp"

namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost {

//////////////////////////////////////////////////////////////////////////
// class bad_get
//
// The exception thrown in the event of a failed get of a value.
//
class BOOST_SYMBOL_VISIBLE bad_get
    : public std::exception
{
public: // std::exception implementation

    virtual const char * what() const BOOST_NOEXCEPT_OR_NOTHROW
    {
        return "geofeatures_boost::bad_get: "
               "failed value get using geofeatures_boost::get";
    }

};

//////////////////////////////////////////////////////////////////////////
// function template get<T>
//
// Retrieves content of given variant object if content is of type T.
// Otherwise: pointer ver. returns 0; reference ver. throws bad_get.
//

namespace detail { namespace variant {

// (detail) class template get_visitor
//
// Generic static visitor that: if the value is of the specified type,
// returns a pointer to the value it visits; else a null pointer.
//
template <typename T>
struct get_visitor
{
private: // private typedefs

    typedef typename add_pointer<T>::type pointer;
    typedef typename add_reference<T>::type reference;

public: // visitor typedefs

    typedef pointer result_type;

public: // visitor interfaces

    pointer operator()(reference operand) const BOOST_NOEXCEPT
    {
        return geofeatures_boost::addressof(operand);
    }

    template <typename U>
    pointer operator()(const U&) const BOOST_NOEXCEPT
    {
        return static_cast<pointer>(0);
    }
};

}} // namespace detail::variant

#ifndef BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE
#   if !BOOST_WORKAROUND(__BORLANDC__, BOOST_TESTED_AT(0x0551))
#       define BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(t)
#   else
#       define BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(t)  \
        , t* = 0
#   endif
#endif

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// relaxed_get<U>(variant) methods
//
template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<U>::type
relaxed_get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
    typedef typename add_pointer<U>::type U_ptr;
    if (!operand) return static_cast<U_ptr>(0);

    detail::variant::get_visitor<U> v;
    return operand->apply_visitor(v);
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<const U>::type
relaxed_get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
    typedef typename add_pointer<const U>::type U_ptr;
    if (!operand) return static_cast<U_ptr>(0);

    detail::variant::get_visitor<const U> v;
    return operand->apply_visitor(v);
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<U>::type
relaxed_get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
    typedef typename add_pointer<U>::type U_ptr;
    U_ptr result = relaxed_get<U>(&operand);

    if (!result)
        geofeatures_boost::throw_exception(bad_get());
    return *result;
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<const U>::type
relaxed_get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
    typedef typename add_pointer<const U>::type U_ptr;
    U_ptr result = relaxed_get<const U>(&operand);

    if (!result)
        geofeatures_boost::throw_exception(bad_get());
    return *result;
}



/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// strict_get<U>(variant) methods
//
template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<U>::type
strict_get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
    BOOST_STATIC_ASSERT_MSG(
        (geofeatures_boost::detail::variant::holds_element<geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >, U >::value),
        "geofeatures_boost::variant does not contain specified type U, "
        "call to geofeatures_boost::get<U>(geofeatures_boost::variant<T...>*) will always return NULL"
    );

    return relaxed_get<U>(operand);
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<const U>::type
strict_get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
    BOOST_STATIC_ASSERT_MSG(
        (geofeatures_boost::detail::variant::holds_element<geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >, const U >::value),
        "geofeatures_boost::variant does not contain specified type U, "
        "call to geofeatures_boost::get<U>(const geofeatures_boost::variant<T...>*) will always return NULL"
    );

    return relaxed_get<U>(operand);
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<U>::type
strict_get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
    BOOST_STATIC_ASSERT_MSG(
        (geofeatures_boost::detail::variant::holds_element<geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >, U >::value),
        "geofeatures_boost::variant does not contain specified type U, "
        "call to geofeatures_boost::get<U>(geofeatures_boost::variant<T...>&) will always throw geofeatures_boost::bad_get exception"
    );

    return relaxed_get<U>(operand);
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<const U>::type
strict_get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
    BOOST_STATIC_ASSERT_MSG(
        (geofeatures_boost::detail::variant::holds_element<geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >, const U >::value),
        "geofeatures_boost::variant does not contain specified type U, "
        "call to geofeatures_boost::get<U>(const geofeatures_boost::variant<T...>&) will always throw geofeatures_boost::bad_get exception"
    );

    return relaxed_get<U>(operand);
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// get<U>(variant) methods
//

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<U>::type
get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
#ifdef BOOST_VARIANT_USE_RELAXED_GET_BY_DEFAULT
    return relaxed_get<U>(operand);
#else
    return strict_get<U>(operand);
#endif

}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_pointer<const U>::type
get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >* operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    ) BOOST_NOEXCEPT
{
#ifdef BOOST_VARIANT_USE_RELAXED_GET_BY_DEFAULT
    return relaxed_get<U>(operand);
#else
    return strict_get<U>(operand);
#endif
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<U>::type
get(
      geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
#ifdef BOOST_VARIANT_USE_RELAXED_GET_BY_DEFAULT
    return relaxed_get<U>(operand);
#else
    return strict_get<U>(operand);
#endif
}

template <typename U, BOOST_VARIANT_ENUM_PARAMS(typename T) >
inline
    typename add_reference<const U>::type
get(
      const geofeatures_boost::variant< BOOST_VARIANT_ENUM_PARAMS(T) >& operand
      BOOST_VARIANT_AUX_GET_EXPLICIT_TEMPLATE_TYPE(U)
    )
{
#ifdef BOOST_VARIANT_USE_RELAXED_GET_BY_DEFAULT
    return relaxed_get<U>(operand);
#else
    return strict_get<U>(operand);
#endif
}

} // namespace geofeatures_boost

#endif // BOOST_VARIANT_GET_HPP
