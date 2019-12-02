/*
 Copyright 2017 Urban Airship and Contributors
 */

import Airship

/**
 * Updates the preference center with new tag preference data provided in a push notification
 */
class UATagPreferencesSaveAction: UAAction {
    
    static let actionName = "ua_tag_preference_save_action"
    
    open override func acceptsArguments(_ arguments: UAActionArguments) -> Bool {
        return (arguments.situation == .backgroundPush || arguments.situation == .foregroundPush || arguments.situation == .manualInvocation || arguments.situation == .foregroundInteractiveButton || arguments.situation == .launchedFromPush)
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
            
            var preferencesToSave: [UATagPreference]?
            var titleToSave: String?

            if let jsonTitle = jsonDict!.object(forKey: jsonKeys.title.rawValue) as? String {
                if jsonTitle != "" {
                    titleToSave = jsonTitle
                }
            }

            if let preferences = jsonDict!.object(forKey: jsonKeys.preferences.rawValue) as? [[String: String]] {
                preferencesToSave = [UATagPreference]()
                for preference in preferences {
                    
                    if let prefTag = preference[jsonKeys.tag.rawValue] {
                        if let prefDisplayName = preference[jsonKeys.displayName.rawValue] {
                            
                            var tagGroup = UATagPreferenceCenterInternal.deviceGroup
                            
                            if let prefTagGroup = preference[jsonKeys.tagGroup.rawValue] {
                                tagGroup = prefTagGroup
                            }
                            
                            if prefTag != "" {
                                let pref = UATagPreference(tag: prefTag, displayName: prefDisplayName, tagGroup: tagGroup)
                                preferencesToSave!.append(pref)
                            }
                        }
                    }
                }
            }
            
            UATagPreferenceCenterInternal.savePreferences(preferences: preferencesToSave, style: nil, title: titleToSave)
            
        } else {
            NSLog("ERROR: Did not find valid JSON data")
        }
        completionHandler(UAActionResult.empty())
    }
    
    class func createAction() {
        if UAirship.shared() == nil {
            NSLog("ERROR: UATagPreferencesSaveAction cannot run unless the Urban Airship SDK is running. Please ensure that UAirship.takeOff has been called in the AppDelegate")
            return
        }
        let actionRegistry = UAirship.shared().actionRegistry
        actionRegistry.register(UATagPreferencesSaveAction(), name: UATagPreferencesSaveAction.actionName)
    }
}
