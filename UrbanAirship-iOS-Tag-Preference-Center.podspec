Pod::Spec.new do |s|
  s.version                 = "1.2.0"
  s.name                    = "UrbanAirship-iOS-Tag-Preference-Center"
  s.summary                 = "Tag based preference center using the Urban Airship SDK"

  s.homepage                = "https://www.urbanairship.com"
  s.author                  = { "Urban Airship" => "support@urbanairship.com" }

  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => 'https://github.com/urbanairship/ios-tag-preference-center.git', :tag => s.version.to_s }

  s.module_name             = "UATagPreferenceCenter"
  s.ios.deployment_target   = "9.0"
  s.requires_arc            = true

  s.source_files            = 'UATagPreferenceCenter/UATagPreferenceCenter/Classes/**/*'

  s.resources               = 'UATagPreferenceCenter/UATagPreferenceCenter/Resources/**/*'

  s.ios.frameworks          = 'UIKIT'
  s.dependency              'UrbanAirship-iOS-SDK', '~> 9.0'
end
