Pod::Spec.new do |s|
    s.name         = "Scootys-Unit-Testing"
    s.version      = "1.0.1"
    s.summary      = "Collection of Unit Testing Utilities"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2024 Scott McCoy
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scotthmccoy@gmail.com" }
    s.source       = { :git => "https://github.com/scotthmccoy/scootys-unit-testing.git", :tag => "#{s.version}" }
    
    s.platform     = :ios, '13.0'
    s.swift_versions = ["5.0"]
    s.pod_target_xcconfig = {
      "ENABLE_TESTING_SEARCH_PATHS" => "YES" # Required for Xcode 12.5
    }

    s.source_files = "Code/**/*.swift"
    s.resource_bundles = { 'ScootysUnitTestingResources' => ["Code/**/*.jpeg"] }
    
    s.frameworks = 'XCTest'
end
