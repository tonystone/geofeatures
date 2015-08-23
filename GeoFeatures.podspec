#
# Be sure to run `pod lib lint GeoFeatures.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "GeoFeatures"
    s.version          = "0.2.6"
    s.summary          = "GeoFeatures is a full Geometry library for working with Points, Polygons, LineStrings, etc."
    s.homepage         = "https://github.com/tonystone"
    s.license          = 'Apache 2.0'
    s.author           = "Tony Stone"
    s.source           = { :git => "https://github.com/tonystone/geofeatures.git", :tag => s.version.to_s }

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.source_files         = 'Pod/*'
    s.public_header_files  = 'Pod/*.h'

    s.subspec 'boost' do |sp|
        sp.header_mappings_dir = 'Pod/Internal'
        sp.source_files        = 'Pod/Internal/boost/**/*.{h,hpp,ipp}'
        sp.public_header_files = 'Pod/Internal/boost/**/*.{h,hpp}'
    end

    s.subspec 'internal' do |sp|
         sp.dependency 'GeoFeatures/boost'

         sp.header_mappings_dir = 'Pod/Internal'
         sp.source_files        = 'Pod/Internal/*',
                                  'Pod/Internal/geofeatures/**/*'
    end

    s.frameworks = 'MapKit'

    s.xcconfig = {
        'GCC_C_LANGUAGE_STANDARD' => 'c11',
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
        'CLANG_CXX_LIBRARY' => 'libc++',
        'OTHER_LDFLAGS' => '-lc++',
    }

end