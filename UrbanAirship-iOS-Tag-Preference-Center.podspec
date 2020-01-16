Pod::Spec.new do |s|
  s.version                 = "2.0.0"
  s.name                    = "UrbanAirship-iOS-Tag-Preference-Center"
  s.summary                 = "Tag based preference center using the Airship SDK"

  s.homepage                = "https://www.airship.com"
  s.author                  = { "Airship" => "support@urbanairship.com" }

  s.license                 = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }

  s.source                  = { :git => 'https://github.com/urbanairship/ios-tag-preference-center.git', :tag => s.version.to_s }

  s.module_name             = "UATagPreferenceCenter"
  s.ios.deployment_target   = "11.0"
  s.requires_arc            = true

  s.source_files            = 'UATagPreferenceCenter/UATagPreferenceCenter/Classes/**/*'

  s.resources               = 'UATagPreferenceCenter/UATagPreferenceCenter/Resources/**/*'

  s.ios.frameworks          = 'UIKIT'
  s.dependency              'Airship', '>= 13.0'
end
