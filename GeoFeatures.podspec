#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name              = "GeoFeatures"
    s.version           = "1.7.0"
    s.summary           = "A lightweight, high performance geometry library for Objective-C"
    s.homepage          = "https://github.com/tonystone/geofeatures"
    s.license           = 'Apache License, Version 2.0'
    s.author            = "Tony Stone"
    s.source            = { :git => "https://github.com/tonystone/geofeatures.git", :tag => s.version.to_s }
    s.documentation_url = "http://tonystone.github.io/geofeatures"

    s.ios.deployment_target     = '6.0'
    s.osx.deployment_target     = '10.7'

    s.requires_arc = true

    s.module_map = 'GeoFeatures.modulemap'

    s.source_files         = 'GeoFeatures/**/*.{mm,m,hpp,h}'
    s.public_header_files  = 'GeoFeatures/*.h'
    s.private_header_files = 'GeoFeatures/internal/**/*.{hpp,h}'

    s.preserve_paths       = 'boost/**/*.{hpp,h}', 'LICENSE_BOOST_1_0'

    s.frameworks = 'MapKit'

    #
    # Note: __ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES flag required to work around
    #       conflict with Apple headers defined in https://svn.boost.org/trac/boost/ticket/10471
    #
    s.pod_target_xcconfig = {
       'GCC_C_LANGUAGE_STANDARD' => 'c11',
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
        'CLANG_CXX_LIBRARY' => 'libc++',
        'OTHER_LDFLAGS' => '-lc++',
        'OTHER_CFLAGS' => '-D__ASSERT_MACROS_DEFINE_VERSIONS_WITHOUT_UNDERSCORES=0',
        'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/boost"'
    }
end
