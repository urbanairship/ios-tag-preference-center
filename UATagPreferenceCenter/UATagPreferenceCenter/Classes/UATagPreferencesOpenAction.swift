/*
 Copyright 2017 Urban Airship and Contributors
 */

import Airship

/**
 * Opens the preference center from a push notification containing a list of tag preferences
 */
class UATagPreferencesOpenAction: UAAction {
    
    static let actionName = "ua_tag_preference_open_action"
    
    private static let styleName = "ua_remote_tag_preference_style"
    
    open override func acceptsArguments(_ arguments: UAActionArguments) -> Bool {
        return (arguments.situation == .backgroundPush || arguments.situation == .manualInvocation || arguments.situation == .foregroundInteractiveButton || arguments.situation == .launchedFromPush)
    }
    
    open override func perform(with arguments: UAActionArguments, completionHandler: @escaping Airship.UAActionCompletionHandler) {
        
        var jsonDict: NSDictionary?
        
        if let dict = arguments.value as? NSDictionary {
            jsonDict = dict
        } else if let jsonString = arguments.value as? String {
            // If payload has been sent through as a string, serialize it into JSON
            if let jsonData = JSONSerialization.object(with: jsonString, options: []) {
                if let dict = jsonData as? NSDictionary {
                    jsonDict = dict
                    
                } else {
                    NSLog("ERROR: No valid preference data found: \(jsonData)")
                }
                
            } else {
                NSLog("ERROR: Did not find valid JSON data: \(jsonString)")
            }
        }
        
        if jsonDict != nil {
            var preferencesToUse = [UATagPreference]()
            var titleToUse = ""
            
            if let jsonTitle = jsonDict!.object(forKey: "title") as? String {
                titleToUse = jsonTitle
            }
            
            if let preferences = jsonDict!.object(forKey: jsonKeys.preferences.rawValue) as? [[String: String]] {
                
                for preference in preferences {
                    
                    if let prefTag = preference[jsonKeys.tag.rawValue] {
                        if let prefDisplayName = preference[jsonKeys.displayName.rawValue] {
                            
                            var tagGroup = UATagPreferenceCenterInternal.deviceGroup
                            
                            if let prefTagGroup = preference[jsonKeys.tagGroup.rawValue] {
                                tagGroup = prefTagGroup
                            }
                            
                            if prefTag != "" {
                                let pref = UATagPreference(tag: prefTag, displayName: prefDisplayName, tagGroup: tagGroup)
                                preferencesToUse.append(pref)
                            }
                        }
                    }
                }
            }

            UATagPreferenceCenter.start(preferences: preferencesToUse, style: UATagPreferencesOpenAction.loadStyle(), title: titleToUse, preferSavedPreferences: false)
        } else {
            NSLog("ERROR: Did not find valid JSON data")
        }
        
        completionHandler(UAActionResult.empty())
    }
    
    class func createAction(style: UATagPreferencesStyle) {
        if UAirship.shared() == nil {
            NSLog("ERROR: UATagPreferencesOpenAction cannot run unless the Urban Airship SDK is running. Please ensure that UAirship.takeOff has been called in the AppDelegate")
            return
        }
        UATagPreferencesOpenAction.setStyle(style: style)
        let actionRegistry = UAirship.shared().actionRegistry
        actionRegistry.register(UATagPreferencesOpenAction(), name: UATagPreferencesOpenAction.actionName)
    }
    
    private class func setStyle(style: UATagPreferencesStyle) {
        let defaults = UserDefaults.standard
        let styleData: Data = NSKeyedArchiver.archivedData(withRootObject: style.getStyleDict())
        defaults.set(styleData, forKey: UATagPreferencesOpenAction.styleName)
    }
    
    private class func loadStyle() -> UATagPreferencesStyle {
        let defaults = UserDefaults.standard
        if let savedStyledict = defaults.object(forKey: UATagPreferencesOpenAction.styleName) as? Data {
            let styleToReturn = NSKeyedUnarchiver.unarchiveObject(with: savedStyledict) as! [String: AnyObject]
            return UATagPreferencesStyle(styles: styleToReturn)
        } else {
            return UATagPreferencesStyle()
        }
    }
}


