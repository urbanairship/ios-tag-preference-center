/*
 Copyright 2017 Urban Airship and Contributors
 */

import UIKit

/**
 * A preference tag selection cell
 */
open class UATagPreferencesViewCell: UITableViewCell {
    
    @IBOutlet weak public var preferenceLabel: UILabel!
    @IBOutlet weak public var preferenceSwitch: UISwitch!
    
    var preferenceTag = ""
    var preferenceTagGroup = ""
    
    var delegate: UATagPreferenceCellDelegate?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func preferenceSwitchTouched(_ sender: Any) {
        if self.preferenceSwitch.isOn == true {
            self.delegate?.preferenceTagSelected(tagName: self.preferenceTag, tagGroup: self.preferenceTagGroup)
            
        } else if self.preferenceSwitch.isOn == false {
            self.delegate?.preferenceTagDeselected(tagName: self.preferenceTag, tagGroup: self.preferenceTagGroup)
        }
    }
}
