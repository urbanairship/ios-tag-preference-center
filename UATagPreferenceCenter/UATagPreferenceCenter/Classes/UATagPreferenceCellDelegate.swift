/*
 Copyright 2017 Urban Airship and Contributors
 */
/**
 * Delegate method for handling cell preference selections
 */
public protocol UATagPreferenceCellDelegate {
    
    /**
     * (required) called when the cell swich has been turned on
     *
     * - parameters:
     *   - tagName: the name of the tag
     *   - tagGroup: the tag group for the tag
     */
    func preferenceTagSelected(tagName: String, tagGroup: String)
    
    /**
     *  (required) called when the cell swich has been turned off
     *
     * - parameters:
     *   - tagName: the name of the tag
     *   - tagGroup: the tag group for the tag
     */
    func preferenceTagDeselected(tagName: String, tagGroup: String)
    
}
