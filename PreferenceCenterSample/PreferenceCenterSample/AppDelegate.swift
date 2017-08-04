/*
 Copyright 2017 Urban Airship and Contributors
 */

import UIKit
import AirshipKit
import UATagPreferenceCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UARegistrationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        if TARGET_OS_SIMULATOR == 0 && TARGET_IPHONE_SIMULATOR == 0 {
            // Set log level for debugging config loading (optional)
            // It will be set to the value in the loaded config upon takeOff
            UAirship.setLogLevel(UALogLevel.debug)
            
            // Populate AirshipConfig.plist with your app's info from https://go.urbanairship.com
            // or set runtime properties here.
            let config = UAConfig.default()
            
            // You can then programmatically override the plist values:
            // config.developmentAppKey = "YourKey"
            // etc.
            
            // Call takeOff (which creates the UAirship singleton)
            UAirship.takeOff(config)
            
            // Print out the application configuration for debugging (optional)
            print("Config:\n \(config)")
            
            // Set the icon badge to zero on startup (optional)
            UAirship.push()?.resetBadge()
            
            // Set self as the UARegistrationDelegate to capture device registration
            UAirship.push().registrationDelegate = self
        } else {
            NSLog("Cannot call takeOff as it looks like you're running in a simulator. Push notications can only be enabled on a device")
        }
        
        
        return true
    }
    
    func registrationSucceeded(forChannelID channelID: String, deviceToken: String) {
        NotificationCenter.default.post(name: MainViewController.registeredChannelID,
                                        object: self,
                                        userInfo: nil)
    }
    
}

