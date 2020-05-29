Pod::Spec.new do |spec|
  spec.name         = "SwiftAnnoy"
  spec.version      = "1.0.0"
  spec.summary      = "Swift bindings for Annoy (Approximate Nearest Neighbors Oh Yeah)"
  spec.description  = <<-DESC
  SwiftAnnoy brings the Annoy (Approximate Nearest Neighbors Oh Yeah) C++ libary to Swift.  Nearest neighbors algorithms are a machine learning tool used for many tasks including classification, clustering, image retreval, and recommendation.  Annoy is particularly useful not just for it's speed, but also as it allows for memory mapping of index files, which is really handy in memory constrained settings (mobile devices, large datasets, ect.).
                   DESC
  spec.homepage     = "https://github.com/jbadger3/SwiftAnnoy"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Jonathan Badger" => "jonathancbadger@gmail.com" }
  spec.social_media_url   = "https://www.linkedin.com/in/jonathan-badger-ab7a2354"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  spec.swift_version = "5.1"
  spec.source       = { :git => "https://github.com/jbadger3/SwiftAnnoy.git", :tag => "#{spec.version}" }



  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  spec.source_files  = "Sources"
  spec.exclude_files = "Tests"

  spec.private_header_files = "Sources/CAnnoyWrapper/*.h",
                              "Sources/CAnnoyWrapper/Include/*.hpp"

end
