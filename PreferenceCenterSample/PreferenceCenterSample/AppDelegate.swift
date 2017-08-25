/*
 Copyright 2017 Urban Airship and Contributors
 */

import UIKit
import AirshipKit
import UATagPreferenceCenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
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
        
        // Enable push notifications
        UAirship.push().userPushNotificationsEnabled = true
        
        // Register the preference center action to allow preferences
        // to be handled throug push notifications
        UATagPreferenceCenter.registerAction()
        
        return true
    }
    
}

