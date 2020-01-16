/*
 Copyright 2017 Urban Airship and Contributors
 */

import Foundation
import Airship

/**
 Manages the setup and display of a preference center view that can be called at any point
 */
public class UATagPreferenceCenter {
    
    // MARK: - Default Preference Center Properties
    
    /**
     * (optional) custom styling for the preference center
     */
    public var style: UATagPreferencesStyle
    
    /**
     * (required) an array of preferences to be displayed
     */
    public var preferences: [UATagPreference]
    
    /**
     * (optional) the title of the preference center
     */
    public var title: String
    
    // MARK: - Initialization
    
    /**
     * Creates a UATagPreferenceCenter object with parameters for styling, tag data etc.
     *
     * - parameters:
     *   - preferences: (optional) an array of UATagPreference objects
     *   - style: (optional) an UATagPreferencesStyle object containing custom style options for the preference center
     *   - title: (optional) a string value indicating the tile to be displayed for the preference center. Defaults to "Notification Preferences"
     */
    public init(preferences: [UATagPreference] = [UATagPreference](), style: UATagPreferencesStyle = UATagPreferencesStyle(), title: String = "") {
        self.style = style
        self.preferences = preferences
        self.title = title
    }
    
    // MARK: - Starting the Preference Center
    
    /**
     * Creates and displays the preference center with stored styles, tag preferences etc
     *
     * - parameters:
     *   - preferSavedPreferences: (optional) set to false to ignore preferences that have have been saved or updated remotely
     */
    public func start(preferSavedPreferences: Bool = true) {
        
        if let validatedPreferences = UATagPreferenceDataHandler.finalizePreferences(preferences: self.preferences, style: self.style, title: self.title, useSavedPreferences: preferSavedPreferences) {
            UATagPreferenceCenter.startup(preferences: validatedPreferences.preferences, style: validatedPreferences.style, preferencesTitle: validatedPreferences.title)
        }
    }

    /**
     * Creates and displays an instance of the preference center with supplied values
     *
     * - parameters:
     *   - preferences: (required) an array of UATagPreference objects
     *   - style: (optional) an UATagPreferencesStyle object containing custom style options for the preference center
     *   - title: (optional) a string value indicating the tile to be displayed for the preference center. Defaults to "Notification Preferences"
     *   - preferSavedPreferences: (optional) set to false to ignore preferences that have have been saved or updated remotely
     */
    public class func start(preferences: [UATagPreference], style: UATagPreferencesStyle = UATagPreferencesStyle(), title: String = "", preferSavedPreferences: Bool = true) {
        
        if let validatedPreferences = UATagPreferenceDataHandler.finalizePreferences(preferences: preferences, style: style, title: title, useSavedPreferences: preferSavedPreferences) {
            UATagPreferenceCenter.startup(preferences: validatedPreferences.preferences, style: validatedPreferences.style, preferencesTitle: validatedPreferences.title)
        }
    }
    
    // MARK: - Registering Actions
    
    /**
     * Sets up UAActions that allow the preference center to be called remotely through a push notification, or updated with new preference tag data
     *
     * - parameters:
     *   - style: (optional) an UATagPreferencesStyle object containing custom style options for the preference center
     *
     * **Important:** This method must be set up after takeOff in order run
     */
    public class func registerAction(style: UATagPreferencesStyle = UATagPreferencesStyle()) {
        UATagPreferencesOpenAction.createAction(style: style)
        UATagPreferencesSaveAction.createAction()
    }
    
    /**
     * Saves specified preferences for later use
     *
     * - parameters:
     *   - preferences: (optional) an array of UATagPreference objects
     *   - title: (optional) a string value indicating the tile to be displayed for the preference center. Defaults to "Notification Preferences"
     *   - style: (optional) an UATagPreferencesStyle object containing custom style options for the preference center
     */
    public class func savePreferences(preferences: [UATagPreference]?, title: String?, style: UATagPreferencesStyle?) {
        UATagPreferenceCenterInternal.savePreferences(preferences: preferences, style: style, title: title)
    }
    
    // MARK: - Clearing Preference Center Data
    
    /**
     * Deletes any saved preference center data
     */
    public class func deleteSavedPreferences() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: UATagPreferenceCenterInternal.savedPreferencesName)
    }
    
    class func getResourceBundle() -> Bundle? {
        return Bundle(for: self)
    }
    
    // MARK: - Private Methods
    
    private class func startup(preferences: [UATagPreference], style: UATagPreferencesStyle, preferencesTitle: String) {
        if UAirship.shared() == nil {
            NSLog("ERROR: UATagPreferenceCenter cannot run unless the Urban Airship SDK is running. Please ensure that UAirship.takeOff has been called in the AppDelegate")
            return
        }
        if let window = UIApplication.shared.keyWindow {
            if let topController = window.rootViewController {
                let preferenceViewController = UATagPreferencesViewController(preferences: preferences, style: style, title: preferencesTitle)
                topController.present(preferenceViewController, animated: true, completion: nil) 
            }
        }
    }
}
