/*
 Copyright 2017 Urban Airship and Contributors
 */

/**
 An single preference tag object
 */
public class UATagPreference {
    
    private (set) var tag: String
    private (set) var displayName: String
    private (set) var tagGroup: String
    
    // MARK: - Initialization
    
    /**
     * Creates a preference tag instance
     *
     * - parameters:
     *   - tag: (required) a string value containing the preference tag to be set
     *   - displayName: (required) a string value. The corresponding preference name that will be displayed
     *   - tagGroup: (optional) a string value detailing the tag group where the preference tag will be stored. If no tag group is declared, the tag will be stored on the device
     *
     * **Important:** A tag group must already have been created in the Urban Airship Dashboard. If not, the tag preference will not be stored
     */
    public init(tag: String, displayName: String, tagGroup: String = "device") {
        self.tag = tag
        
        // ensure that a blank display name is not set
        if displayName != "" {
            self.displayName = displayName
        } else {
            self.displayName = tag
        }
        
        // ensure that a blank tag group is not set
        if tagGroup != "" {
            self.tagGroup = tagGroup
        } else {
            self.tagGroup = "device"
        }
    }
}
