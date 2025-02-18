

Pod::Spec.new do |spec|

  spec.name         = "NetworkManager"
  spec.version      = "1.0.0"
  spec.summary      = "NetworkManager is a compact library created for working with network."

  spec.description  = <<-DESC
  NetworkManager is a compact library created for working with network.
                   DESC

  spec.homepage     = "https://github.com/gmetsanurk/currency_converter_gmetsanurk.git"

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  spec.author       = { "Georgy Metsanurk" => "gmetsanurk@gmail.com" }

  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  # spec.visionos.deployment_target = "1.0"

  spec.source       = { :path => "." }
  
  spec.swift_version = "5.0"
  spec.ios.deployment_target = "14.0"
  spec.tvos.deployment_target = "14.0"
  
  spec.source_files  = "Sources/NetworkManager/**/*.{swift,h,m}"
  #spec.exclude_files = "Classes/Exclude"
  # spec.public_header_files = "Classes/**/*.h"

  spec.dependency "Alamofire", "~> 5.0"
  spec.dependency "Moya", "~> 15.0"
  spec.dependency "Moya/Combine", "~> 15.0"
end
