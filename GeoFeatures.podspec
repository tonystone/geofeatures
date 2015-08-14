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
    s.version          = "0.2.5"
    s.summary          = "GeoFeatures is a full Geometry library for working with Points, Polygons, LineStrings, etc."
    s.homepage         = "http://www.climate.com"
    s.license          = 'MIT'
    s.author           = { "Tony Stone" => "tony@mobilegridinc.com" }
    s.source           = { :git => "ssh://git@stash.ci.climatedna.net:7999/fdi/geofeatures-ios.git", :tag => s.version.to_s }

    s.platform     = :ios, '8.0'
    s.requires_arc = true

    s.public_header_files = 'Pod/Classes/*.h'
    s.private_header_files = 'Pod/Classes/Internal/**/*.{h,hhp}'
    s.source_files = 'Pod/Classes/*'
    s.resource_bundles = {
        'GeoFeatures' => ['Pod/Assets/*.png']
    }

    s.subspec 'Internal' do |sp|
        sp.source_files = 'Pod/Classes/Internal/**/*'
    end

    s.frameworks = 'MapKit'
    s.dependency 'boost', "0.1.1"

    s.xcconfig = {
        'GCC_C_LANGUAGE_STANDARD' => 'c11',
        'CLANG_CXX_LANGUAGE_STANDARD' => 'c++0x',
        'CLANG_CXX_LIBRARY' => 'libc++',
        'OTHER_LDFLAGS' => '-lc++',
    }

end