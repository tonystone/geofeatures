// Boost.Geometry (aka GGL, Generic Geometry Library)

// Copyright (c) 2010-2012 Barend Gehrels, Amsterdam, the Netherlands.

// Use, modification and distribution is subject to the Boost Software License,
// Version 1.0. (See accompanying file LICENSE_1_0.txt or copy at
// http://www.boost.org/LICENSE_1_0.txt)

#ifndef BOOST_GEOMETRY_GEOMETRIES_ADAPTED_BOOST_POLYGON_RING_PROXY_HPP
#define BOOST_GEOMETRY_GEOMETRIES_ADAPTED_BOOST_POLYGON_RING_PROXY_HPP

// Adapts Geometries from Boost.Polygon for usage in Boost.Geometry
// geofeatures_boost::polygon::polygon_with_holes_data -> geofeatures_boost::geometry::polygon
//   pair{begin_points, end_points} -> ring_proxy

#include <boost/polygon/polygon.hpp>
#include <boost/range.hpp>



namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost { namespace geometry
{

namespace adapt { namespace bp
{

namespace detail
{

template <bool Mutable>
struct modify
{};

template <>
struct modify<true>
{
    template <typename Ring, typename Point>
    static inline void push_back(Ring& ring, Point const& point)
    {
        // Boost.Polygon's polygons are not appendable. So create a temporary vector,
        // add a record and set it to the original. Of course: this is not efficient.
        // But there seems no other way (without using a wrapper)
        std::vector<Point> temporary_vector
            (
                geofeatures_boost::polygon::begin_points(ring),
                geofeatures_boost::polygon::end_points(ring)
            );
        temporary_vector.push_back(point);
        geofeatures_boost::polygon::set_points(ring, temporary_vector.begin(), temporary_vector.end());
    }

};

template <>
struct modify<false>
{
    template <typename Ring, typename Point>
    static inline void push_back(Ring& ring, Point const& point)
    {
    }

};


}


// Polygon should implement the geofeatures_boost::polygon::polygon_with_holes_concept
// Specify constness in the template parameter if necessary
template<typename Polygon>
class ring_proxy
{
public :
    typedef typename geofeatures_boost::polygon::polygon_traits
        <
            typename geofeatures_boost::remove_const<Polygon>::type
        >::iterator_type iterator_type;

    typedef typename geofeatures_boost::polygon::polygon_with_holes_traits
        <
            typename geofeatures_boost::remove_const<Polygon>::type
        >::iterator_holes_type hole_iterator_type;

    static const bool is_mutable = !geofeatures_boost::is_const<Polygon>::type::value;

    inline ring_proxy(Polygon& p)
        : m_polygon_pointer(&p)
        , m_do_hole(false)
    {}

    // Constructor used from hole_iterator
    inline ring_proxy(Polygon& p, hole_iterator_type hole_it)
        : m_polygon_pointer(&p)
        , m_do_hole(true)
        , m_hole_it(hole_it)
    {}

    // Default constructor, for mutable polygons / appending (interior) rings
    inline ring_proxy()
        : m_polygon_pointer(&m_polygon_for_default_constructor)
        , m_do_hole(false)
    {}


    iterator_type begin() const
    {
        return m_do_hole
            ? geofeatures_boost::polygon::begin_points(*m_hole_it)
            : geofeatures_boost::polygon::begin_points(*m_polygon_pointer)
            ;
    }

    iterator_type begin()
    {
        return m_do_hole
            ? geofeatures_boost::polygon::begin_points(*m_hole_it)
            : geofeatures_boost::polygon::begin_points(*m_polygon_pointer)
            ;
    }

    iterator_type end() const
    {
        return m_do_hole
            ? geofeatures_boost::polygon::end_points(*m_hole_it)
            : geofeatures_boost::polygon::end_points(*m_polygon_pointer)
            ;
    }

    iterator_type end()
    {
        return m_do_hole
            ? geofeatures_boost::polygon::end_points(*m_hole_it)
            : geofeatures_boost::polygon::end_points(*m_polygon_pointer)
            ;
    }

    // Mutable
    void clear()
    {
        Polygon p;
        if (m_do_hole)
        {
            // Does NOT work see comment above
        }
        else
        {
            geofeatures_boost::polygon::set_points(*m_polygon_pointer,
                geofeatures_boost::polygon::begin_points(p),
                geofeatures_boost::polygon::end_points(p));
        }
    }

    void resize(std::size_t /*new_size*/)
    {
        if (m_do_hole)
        {
            // Does NOT work see comment above
        }
        else
        {
            // TODO: implement this by resizing the container
        }
    }



    template <typename Point>
    void push_back(Point const& point)
    {
        if (m_do_hole)
        {
            //detail::modify<is_mutable>::push_back(*m_hole_it, point);
            //std::cout << "HOLE: " << typeid(*m_hole_it).name() << std::endl;
            //std::cout << "HOLE: " << typeid(m_hole_it).name() << std::endl;
            //std::cout << "HOLE: " << typeid(hole_iterator_type).name() << std::endl;

            // Note, ths does NOT work because hole_iterator_type is defined
            // as a const_iterator by Boost.Polygon

        }
        else
        {
            detail::modify<is_mutable>::push_back(*m_polygon_pointer, point);
        }
    }

private :
    Polygon* m_polygon_pointer;
    bool m_do_hole;
    hole_iterator_type m_hole_it;

    Polygon m_polygon_for_default_constructor;
};




// Support geometry::adapt::bp::ring_proxy for Boost.Range ADP
template<typename Polygon>
inline typename geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon>::iterator_type
            range_begin(geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon>& proxy)
{
    return proxy.begin();
}

template<typename Polygon>
inline typename geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon const>::iterator_type
            range_begin(geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon const> const& proxy)
{
    return proxy.begin();
}

template<typename Polygon>
inline typename geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon>::iterator_type
            range_end(geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon>& proxy)
{
    return proxy.end();
}

template<typename Polygon>
inline typename geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon const>::iterator_type
            range_end(geofeatures_boost::geometry::adapt::bp::ring_proxy<Polygon const> const& proxy)
{
    return proxy.end();
}




}} // namespace adapt::bp


namespace traits
{

template <typename Polygon>
struct tag<adapt::bp::ring_proxy<Polygon> >
{
    typedef ring_tag type;
};


template <typename Polygon>
struct rvalue_type<adapt::bp::ring_proxy<Polygon> >
{
    typedef adapt::bp::ring_proxy<Polygon> type;
};

template <typename Polygon>
struct clear<adapt::bp::ring_proxy<Polygon> >
{
    static inline void apply(adapt::bp::ring_proxy<Polygon> proxy)
    {
        proxy.clear();
    }
};


template <typename Polygon>
struct resize<adapt::bp::ring_proxy<Polygon> >
{
    static inline void apply(adapt::bp::ring_proxy<Polygon> proxy, std::size_t new_size)
    {
        proxy.resize(new_size);
    }
};

template <typename Polygon>
struct push_back<adapt::bp::ring_proxy<Polygon> >
{
    static inline void apply(adapt::bp::ring_proxy<Polygon> proxy,
        typename geofeatures_boost::polygon::polygon_traits<Polygon>::point_type const& point)
    {
        proxy.push_back(point);
    }
};


} // namespace traits

}} // namespace geofeatures_boost::geometry

// Specialize ring_proxy for Boost.Range
namespace geofeatures_boost {} namespace boost = geofeatures_boost; namespace geofeatures_boost
{
    template<typename Polygon>
    struct range_mutable_iterator<geometry::adapt::bp::ring_proxy<Polygon> >
    {
        typedef typename geometry::adapt::bp::ring_proxy<Polygon>::iterator_type type;
    };

    template<typename Polygon>
    struct range_const_iterator<geometry::adapt::bp::ring_proxy<Polygon> >
    {
        typedef typename geometry::adapt::bp::ring_proxy<Polygon const>::iterator_type type;
    };

} // namespace geofeatures_boost


#endif // BOOST_GEOMETRY_GEOMETRIES_ADAPTED_BOOST_POLYGON_RING_PROXY_HPP
