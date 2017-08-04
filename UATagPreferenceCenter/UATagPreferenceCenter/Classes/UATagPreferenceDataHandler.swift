/*
 Copyright 2017 Urban Airship and Contributors
 */

import AirshipKit

class UATagPreferenceDataHandler {
    
    var delegate: UATagPreferencesDelegate?
    var jsonData: NSDictionary?
    var useTagGroups: Bool = false
    
    private (set) var userPreferences: [UATagPreference]
    private var allPreferenceData = [(tagPreference: UATagPreference, hasTag: Bool)]()
    private var allDeviceTagGroupsAndTags = [String: [String]]()
    
    // MARK: - Initialization
    
    init(with preferences: [UATagPreference] = [UATagPreference]()) {
        
        self.userPreferences = preferences
        
        for preference in preferences {
            self.allPreferenceData.append((preference, false))
            
            if preference.tagGroup != UATagPreferenceCenterInternal.deviceGroup {
                self.useTagGroups = true
            }
        }
    }
    
    // MARK: - Tag Preparation
    
    private func getData(from endpoint: endPoint) {
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        var dataTask: URLSessionDataTask?
        
        if dataTask != nil {
            dataTask?.cancel()
        }
        
        let url = URL(string: "https://\(UAirship.shared().config.appKey!):\(UAirship.shared().config.appSecret!)@go.urbanairship.com/api/\(endPoint.channel.rawValue)/\(UAirship.push().channelID!)")!
        let shouldPerformRequest = true
        
        if shouldPerformRequest == true {
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                if let error = error {
                    NSLog("ERROR: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        do {
                            if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                                if json.count > 0 {
                                    self.jsonData = json
                                }
                            } else {
                                NSLog("ERROR: json not formatted correctly")
                            }
                        }
                        catch {
                            NSLog("ERROR: not valid json data")
                        }
                    } else {
                        NSLog("ERROR: not 200 response: \(httpResponse)")
                    }
                }
                self.processData()
            }
            dataTask!.resume()
        }
    }
    
    func prepareTags() {
        if self.useTagGroups == true {
            self.getData(from: .channel)
        } else {
            self.processData()
        }
    }
    
    private func processData(){
        // sort data for tag groups
        if self.useTagGroups == true {
            self.prepareDeviceTagGroupData()
        } else {
            // sort data for device tags
            self.allDeviceTagGroupsAndTags[UATagPreferenceCenterInternal.deviceGroup] = UAirship.push().tags
        }
        
        self.comparePreferenceAndDeviceTags()
        
        if let _ = self.delegate {
            self.delegate!.preferenceDeviceData = self.allPreferenceData
            self.delegate!.tagDataRetrieved(withData: self.allPreferenceData)
        } else {
            NSLog("ERROR: no UATagPreferencesDelegate set")
        }
    }
    
    private func prepareDeviceTagGroupData() {
        if let data = self.jsonData {
            if let channelData = data.object(forKey: apiKeys.channel.rawValue) as? NSDictionary {
                
                // check for existing tag groups
                if let tagGroups = channelData.object(forKey: apiKeys.tagGroups.rawValue) as? NSDictionary {
                    for (key, value) in tagGroups {
                        if let deviceTagGroup = key as? String {
                            if !deviceTagGroup.hasPrefix("ua_") && deviceTagGroup != "timezone" {
                                if let groupTags = value as? [String] {
                                    self.allDeviceTagGroupsAndTags[deviceTagGroup] = groupTags
                                }
                            }
                        }
                    }
                }
                
                // check for existing device tags
                if let deviceTags = channelData.object(forKey: apiKeys.tags.rawValue) as? [String] {
                    self.allDeviceTagGroupsAndTags[UATagPreferenceCenterInternal.deviceGroup] = deviceTags
                }
                
            } else {
                NSLog("ERROR: channel data is not valid")
            }
        } else {
            NSLog("ERROR: nothing to run, no data")
        }
    }
    
    private func comparePreferenceAndDeviceTags() {
        
        var counter = 0
        for preferenceData in self.allPreferenceData {
            if let deviceTagGroupTags = self.allDeviceTagGroupsAndTags[preferenceData.tagPreference.tagGroup] {
                if deviceTagGroupTags.contains(preferenceData.tagPreference.tag) {
                    self.allPreferenceData[counter].hasTag = true
                }
            }
            
            counter += 1
        }
    }
    
    class func convertPreferencesToArrays(preferences: [UATagPreference]) -> (tags: [String], displayNames: [String], tagGroups: [String])? {
        
        var allPreferenceTags = [String]()
        var allPreferenceDisplayNames = [String]()
        var allPreferenceTagGroups = [String]()
        
        for preference in preferences {
            allPreferenceTags.append(preference.tag)
            allPreferenceDisplayNames.append(preference.displayName)
            allPreferenceTagGroups.append(preference.tagGroup)
        }
        
        if allPreferenceTags.count > 0 && (allPreferenceTags.count == allPreferenceDisplayNames.count && allPreferenceTags.count == allPreferenceTagGroups.count) {
            return (tags: allPreferenceTags, displayNames: allPreferenceDisplayNames, tagGroups: allPreferenceTagGroups)
        } else {
            return nil
        }
    }
    
    class func convertArraysToPreferences(tags: [String], displayNames: [String], tagGroups: [String]) -> [UATagPreference]? {
        
        var prefsToReturn: [UATagPreference]?
        
        if tags.count > 0 && (tags.count == displayNames.count && tags.count == tagGroups.count) {
            prefsToReturn = [UATagPreference]()
            for tagIndex in 0...tags.count - 1 {
                let pref = UATagPreference(tag: tags[tagIndex], displayName: displayNames[tagIndex], tagGroup: tagGroups[tagIndex])
                prefsToReturn!.append(pref)
            }
        }
        return prefsToReturn
    }
    
    class func finalizePreferences(preferences: [UATagPreference]?, style: UATagPreferencesStyle?, title: String?, useSavedPreferences: Bool) -> (preferences: [UATagPreference], style: UATagPreferencesStyle, title: String)? {
        var prefsToReturn: [UATagPreference]?
        var styleToReturn: UATagPreferencesStyle?
        var titleToReturn: String?
        
        if preferences != nil {
            prefsToReturn = preferences
        }
        
        if style != nil {
            styleToReturn = style
        }
        
        if title != nil {
            titleToReturn = title
        }
        
        if useSavedPreferences == true {
            if let loadedPreferences = UATagPreferenceDataHandler.load() {
                
                if let savedTags = loadedPreferences[saveKeys.preferenceTags.rawValue] as? [String] {
                    
                    if let savedDisplayNames = loadedPreferences[saveKeys.preferenceNames.rawValue] as? [String] {
                        
                        if let savedTagGroups = loadedPreferences[saveKeys.preferenceTagGroups.rawValue] as? [String] {
                            
                            if let convertedArrays = UATagPreferenceDataHandler.convertArraysToPreferences(tags: savedTags, displayNames: savedDisplayNames, tagGroups: savedTagGroups) {
                                prefsToReturn = convertedArrays
                            }
                        }
                    }
                }
                
                if let savedStyle = loadedPreferences[saveKeys.style.rawValue] as? [String: AnyObject] {
                    styleToReturn = UATagPreferencesStyle(styles: savedStyle)
                }
                
                if let savedTitle = loadedPreferences[saveKeys.title.rawValue] as? String {
                    titleToReturn = savedTitle
                }
            }
        }
        
        if prefsToReturn != nil && styleToReturn != nil && titleToReturn != nil {
            return (preferences: prefsToReturn!, style: styleToReturn!, title: titleToReturn!)
        } else {
            NSLog("ERROR: All preferences could not be validated. Preference Center cannot be loaded.")
            return nil
        }
    }
    
    // MARK: - Saving and Loading
    
    class func save(preferenceArrays: (tags: [String], displayNames: [String], tagGroups: [String])?, style: UATagPreferencesStyle?, title: String?) {
        
        var prefsToSave = NSMutableDictionary()
        
        if let savedPrefs = UATagPreferenceDataHandler.load() as? NSMutableDictionary {
            prefsToSave = savedPrefs
        }
        
        if preferenceArrays != nil {
            prefsToSave[saveKeys.preferenceTags.rawValue] = preferenceArrays!.tags
            prefsToSave[saveKeys.preferenceNames.rawValue] = preferenceArrays!.displayNames
            prefsToSave[saveKeys.preferenceTagGroups.rawValue] = preferenceArrays!.tagGroups
        }
        
        if title != nil {
            prefsToSave[saveKeys.title.rawValue] = title
        }
        
        if style != nil {
            prefsToSave[saveKeys.style.rawValue] = style
        }
        
        let defaults = UserDefaults.standard
        let prefData: Data = NSKeyedArchiver.archivedData(withRootObject: prefsToSave)
        defaults.set(prefData, forKey: UATagPreferenceCenterInternal.savedPreferencesName)
    }
    
    class func load() -> NSDictionary? {
        let defaults = UserDefaults.standard
        if let savedPreferencesData = defaults.object(forKey: UATagPreferenceCenterInternal.savedPreferencesName) as? Data {
            return NSKeyedUnarchiver.unarchiveObject(with: savedPreferencesData) as? NSDictionary
        } else {
            return nil
        }
    }
    
}
