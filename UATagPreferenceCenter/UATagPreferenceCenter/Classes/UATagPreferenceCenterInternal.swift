/*
 Copyright 2017 Urban Airship and Contributors
 */

import Foundation
import AirshipKit

class UATagPreferenceCenterInternal {
    
    var title: String = ""
    var useTagGroups: Bool = false
    
    private let dataHandler: UATagPreferenceDataHandler
    private (set) var preferenceCenterStyle: UATagPreferencesStyle
    
    static let savedPreferencesName = "saved_preferences"
    static let deviceGroup = "device"
    
    // MARK: - Initiazation
    
    init() {
        self.dataHandler = UATagPreferenceDataHandler()
        self.preferenceCenterStyle = UATagPreferencesStyle()
    }
    
    init(preferences: [UATagPreference], preferenceStyle: UATagPreferencesStyle = UATagPreferencesStyle(), preferenceDelegate: UATagPreferencesDelegate?, title: String = "") {
        
        self.dataHandler = UATagPreferenceDataHandler(with: preferences)

        self.preferenceCenterStyle = preferenceStyle
        if preferenceDelegate != nil {
            self.dataHandler.delegate = preferenceDelegate
        }
        
        self.title = title
    }
    
    // MARK: - Adding and Removing Tags
    
    func addPreference(named: String, tagGroup: String) {
        if tagGroup != UATagPreferenceCenterInternal.deviceGroup {
            UAirship.push().addTags([named], group: tagGroup)
        } else {
            UAirship.push().addTag(named)
        }
        
        UAirship.push().updateRegistration()
    }
    
    func removePreference(named: String, tagGroup: String) {
        if tagGroup != UATagPreferenceCenterInternal.deviceGroup {
            UAirship.push().removeTags([named], group: tagGroup)
        } else {
            UAirship.push().removeTag(named)
        }
        
        UAirship.push().updateRegistration()
    }
    
    // MARK: - Preference Preparation & Saving 
    
    func getTagData() {
        self.dataHandler.prepareTags()
    }
    
    class func savePreferences(preferences: [UATagPreference]?, style: UATagPreferencesStyle?, title: String?) {
        
        if preferences != nil {
            
            UATagPreferenceDataHandler.save(preferenceArrays: UATagPreferenceDataHandler.convertPreferencesToArrays(preferences: preferences!), style: style, title: title)
            
        } else {
            UATagPreferenceDataHandler.save(preferenceArrays: nil, style: style, title: title)
        }
    }
    
}


