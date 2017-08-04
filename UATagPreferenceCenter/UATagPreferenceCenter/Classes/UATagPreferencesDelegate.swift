/*
 Copyright 2017 Urban Airship and Contributors
 */
/**
 * Delegate method for handling preference changes
 */
public protocol UATagPreferencesDelegate {
    
    /**
     * (required) preference information set by preferenceDeviceData
     */
    var preferenceDeviceData: [(tagPreference: UATagPreference, hasTag: Bool)]? {get set}
    
    /**
     * (required) - called once all device tag information has been retrieved
     *
     * - parameters:
     *   - withData: an array of preference information that has been retrieved
     */
    func tagDataRetrieved(withData: [(tagPreference: UATagPreference, hasTag: Bool)])
    
}
