/*
 Copyright 2017 Urban Airship and Contributors
 */

import UIKit
import AirshipKit

/**
 * Displays a list of tag based preferences
 */
open class UATagPreferencesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UATagPreferencesDelegate, UATagPreferenceCellDelegate {
    
    @IBOutlet weak public var preferencesTable: UITableView!
    @IBOutlet weak public var closeButton: UIButton!
    @IBOutlet weak public var preferencesTitleLabel: UILabel!
    
    // MARK: - Preference View Controller Properties
    
    /**
     * (required) an array of preferences to display
     */
    public var preferences: [UATagPreference]?
    
    /**
     * (optional) custom styling for the preference center
     */
    public var style: UATagPreferencesStyle = UATagPreferencesStyle()
    
    /**
     * (optional) the title of the preference center
     */
    public var preferencesTitle: String?
    
    public var preferenceDeviceData: [(tagPreference: UATagPreference, hasTag: Bool)]?
    
    /**
     * (optional) prefer to use preferences that have been updated remotely (defaults to true)
     */
    public var preferSavedPreferences: Bool = true
    
    var preferencesInternal: UATagPreferenceCenterInternal?
    
    var loadingAnimation = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isLoadingComplete = false
    
    static let defaultTitle = "Notification Preferences"
    
    // MARK: - Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        if nibNameOrNil == nil && nibBundleOrNil == nil {
            super.init(nibName: "UATagPreferencesViewController", bundle: UATagPreferenceCenter.getResourceBundle())
        } else {
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(nibName: "UATagPreferencesViewController", bundle: UATagPreferenceCenter.getResourceBundle())
    }
    
    convenience public init(preferences: [UATagPreference], style: UATagPreferencesStyle = UATagPreferencesStyle(), title: String?, preferSavedPreferences: Bool = true) {
        self.init()
        self.preferences = preferences
        self.style = style
        self.preferencesTitle = title
        self.preferSavedPreferences = preferSavedPreferences
        self.setup()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UAirship.shared() == nil {
            NSLog("ERROR: UATagPreferencesViewController cannot run unless the Urban Airship SDK is running. Please ensure that UAirship.takeOff has been called in the AppDelegate")
            return
        }
        
        let cellNib = UINib(nibName: "UATagPreferencesViewCell", bundle: UATagPreferenceCenter.getResourceBundle())
        self.preferencesTable.register(cellNib, forCellReuseIdentifier: "UATagPreferencesViewCell")
        
        // If no preference title is provided, hide the label and close button
        if self.preferencesTitle == nil {
            // check that items are not already removed
            if self.preferencesTitleLabel != nil {
                self.preferencesTitleLabel.removeFromSuperview()
                self.preferencesTitleLabel.isHidden = true
            }
            if self.closeButton != nil {
                self.closeButton.removeFromSuperview()
                self.closeButton.isHidden = true
            }
        } else {
            self.preferencesTitleLabel.text = self.preferencesTitle
            self.preferencesTitleLabel.font = self.style.titleFont
            self.preferencesTitleLabel.textColor = self.style.titleColor
            self.closeButton.tintColor = self.style.closeButtonColor
            self.closeButton.titleLabel?.font = self.style.closeButtonFont
            
            if self.preferencesTitle == "" {
                self.preferencesTitle = UATagPreferencesViewController.defaultTitle
            }
        }
        
        // table styles
        self.view.backgroundColor = self.style.backgroundColor
        self.preferencesTable.backgroundColor = self.style.listColor
        self.preferencesTable.separatorColor = self.style.cellSeparatorColor
        
        self.startLoadAnimation()
        
        if self.preferSavedPreferences {
            if let finalizedPrefs = UATagPreferenceDataHandler.finalizePreferences(preferences: self.preferences, style: self.style, title: self.title, useSavedPreferences: self.preferSavedPreferences) {
                self.preferences = finalizedPrefs.preferences
            }
        }
        
        if let _ = self.preferencesInternal {
            self.preferencesInternal!.getTagData()
        } else {
            self.setup()
            if let _ = self.preferencesInternal {
                self.preferencesInternal!.getTagData()
            }
        }
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UATagPreferencesViewCell", for: indexPath) as! UATagPreferencesViewCell
        cell.delegate = self
        if let _ = self.preferenceDeviceData {
            
            cell.preferenceTag = self.preferenceDeviceData![indexPath.row].tagPreference.tag
            cell.preferenceTagGroup = self.preferenceDeviceData![indexPath.row].tagPreference.tagGroup
            cell.preferenceLabel.text = self.preferenceDeviceData![indexPath.row].tagPreference.displayName
            
            // cell styling
            cell.preferenceLabel.font = self.preferencesInternal!.preferenceCenterStyle.preferenceLabelFont
            cell.preferenceLabel.textColor = self.preferencesInternal!.preferenceCenterStyle.preferenceLabelColor
            cell.backgroundColor = self.preferencesInternal!.preferenceCenterStyle.cellBackgroundColor
            cell.preferenceSwitch.onTintColor = self.preferencesInternal!.preferenceCenterStyle.cellSwitchOnColor
            cell.preferenceSwitch.tintColor = self.preferencesInternal!.preferenceCenterStyle.cellSwitchOffTintColor
            
            cell.preferenceSwitch.isOn = self.preferenceDeviceData![indexPath.row].hasTag
        }
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoadingComplete == false {
            return 0
        } else {
            if let _ = self.preferenceDeviceData {
                return self.preferenceDeviceData!.count
            } else {
                return 0
            }
        }
    }
    
    @IBAction public func closeButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func tagDataRetrieved(withData: [(tagPreference: UATagPreference, hasTag: Bool)]) {
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.main.async {
                self.stopLoadAnimation()
                self.preferencesTable.reloadData()
            }
        }
    }
    
    public func startLoadAnimation() {
        isLoadingComplete = false
        
        self.loadingAnimation.center = self.preferencesTable.center
        self.loadingAnimation.color = UIColor.red
        
        self.view.addSubview(loadingAnimation)
        self.preferencesTable.isHidden = true
        
        self.loadingAnimation.startAnimating()
    }
    
    public func stopLoadAnimation() {
        self.isLoadingComplete = true
        self.preferencesTable.isHidden = false
        self.loadingAnimation.stopAnimating()
    }
    
    func setup() {
        if self.preferences != nil {
            if self.preferences!.count > 0 {
                if self.preferencesTitle != nil {
                    self.preferencesInternal = UATagPreferenceCenterInternal(preferences: self.preferences!, preferenceStyle: self.style.copy() as! UATagPreferencesStyle, preferenceDelegate: self, title: self.preferencesTitle!)
                } else {
                    self.preferencesInternal = UATagPreferenceCenterInternal(preferences: self.preferences!, preferenceStyle: self.style.copy() as! UATagPreferencesStyle, preferenceDelegate: self)
                }
                
            }
        } else {
            NSLog("ERROR: There are no preferences to show. Ensure that you provide an array to self.preferences before the view loads")
        }
    }
    
    // MARK: - UATagPreferenceCellDelegate
    
    public func preferenceTagSelected(tagName: String, tagGroup: String) {
        self.preferencesInternal?.addPreference(named: tagName, tagGroup: tagGroup)
    }
    
    public func preferenceTagDeselected(tagName: String, tagGroup: String) {
        self.preferencesInternal?.removePreference(named: tagName, tagGroup: tagGroup)
    }
}
