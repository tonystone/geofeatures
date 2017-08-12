// swift-tools-version:4.0
///
///  Package.swift
///
///  Copyright (c) 2016 Tony Stone
///
///  Licensed under the Apache License, Version 2.0 (the "License");
///  you may not use this file except in compliance with the License.
///  You may obtain a copy of the License at
///
///  http://www.apache.org/licenses/LICENSE-2.0
///
///  Unless required by applicable law or agreed to in writing, software
///  distributed under the License is distributed on an "AS IS" BASIS,
///  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
///  See the License for the specific language governing permissions and
///  limitations under the License.
///
///  Created by Tony Stone on 4/29/2016.
///
import PackageDescription

let package = Package(
    name: "GeoFeatures",
    products: [
        /// Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "GeoFeatures",
            targets: ["GeoFeatures"])
        ],
    dependencies: [
        /// Dependencies declare other packages that this package depends on.
        /// .package(url: packageURL, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "GeoFeatures",
            dependencies: []),
        .testTarget(
            name: "GeoFeaturesTests",
            dependencies: ["GeoFeatures"])
        ]
)
