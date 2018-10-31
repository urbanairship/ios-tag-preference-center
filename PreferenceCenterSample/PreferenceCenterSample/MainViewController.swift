/*
 Copyright 2017 Urban Airship and Contributors
 */

import UIKit
import AirshipKit
import UATagPreferenceCenter

enum tagName: String {
    
    case breakingWorld, breakingSports, breakingFinance, breakingWeather, worldNews, sports, finance, weather
    
    static let breakingTagNames = ["breakingWorld",
                                   "breakingSports",
                                   "breakingFinance",
                                   "breakingWeather"]
    
    static let generalTagNames = ["worldNews",
                                  "sports",
                                  "finance",
                                  "weather"]
}

class MainViewController: UIViewController {

    @IBOutlet weak var breakingNewsButton: UIButton!
    @IBOutlet weak var generalNewsButton: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelButton: UIButton!
    @IBOutlet weak var breakingSubsTextView: UITextView!
    @IBOutlet weak var generalSubsTextView: UITextView!
    
    static let registeredChannelID = Notification.Name(rawValue: "registeredChannelID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(MainViewController.setup),
            name: NSNotification.Name(UAChannelCreatedEvent),
            object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }
    
    // MARK: - Preparing the preference center within a segue
    
    // this example uses GeneralNewsPrefsStyle.plist for styling
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tagPrefVC = segue.destination as? UATagPreferencesViewController {
            
            var generalNewsPrefs = [UATagPreference]()
            
            generalNewsPrefs.append(UATagPreference(tag: tagName.worldNews.rawValue,
                                                    displayName: self.getDisplayName(tagName.worldNews.rawValue)))
            generalNewsPrefs.append(UATagPreference(tag: tagName.sports.rawValue,
                                                    displayName: self.getDisplayName(tagName.sports.rawValue)))
            generalNewsPrefs.append(UATagPreference(tag: tagName.finance.rawValue,
                                                    displayName: self.getDisplayName(tagName.finance.rawValue)))
            generalNewsPrefs.append(UATagPreference(tag: tagName.weather.rawValue,
                                                    displayName: self.getDisplayName(tagName.weather.rawValue)))
            tagPrefVC.preferences = generalNewsPrefs
            tagPrefVC.style = UATagPreferencesStyle(contentsOfFile: "GeneralNewsPrefsStyle")
            
            tagPrefVC.title = "General News Preferences"
        }
    }
    
    // MARK: - Preparing the preference center for a modal view
    
    // this example styles the preference center directly
    @IBAction func showBreakingNewsPrefs(_ sender: Any) {
        let breakingLocal = UATagPreference(tag: tagName.breakingWorld.rawValue,
                                            displayName: self.getDisplayName(tagName.breakingWorld.rawValue))
        let breakingSports = UATagPreference(tag: tagName.breakingSports.rawValue,
                                             displayName: self.getDisplayName(tagName.breakingSports.rawValue))
        let breakingFinance = UATagPreference(tag: tagName.breakingFinance.rawValue,
                                              displayName: self.getDisplayName(tagName.breakingFinance.rawValue))
        let breakingWeather = UATagPreference(tag: tagName.breakingWeather.rawValue,
                                              displayName: self.getDisplayName(tagName.breakingWeather.rawValue))
        
        let breakingStyle = UATagPreferencesStyle()
        
        breakingStyle.backgroundColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.00)
        breakingStyle.listColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.00)
        breakingStyle.cellBackgroundColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.00)
        breakingStyle.closeButtonColor = UIColor(red:0.87, green:0.64, blue:0.15, alpha:1.00)
        breakingStyle.closeButtonFont = UIFont(name: "AvenirNext-Medium", size: 18)
        breakingStyle.cellSwitchOnColor = UIColor(red:0.87, green:0.64, blue:0.15, alpha:1.00)
        breakingStyle.cellSeparatorColor = UIColor(red:0.77, green:0.76, blue:0.75, alpha:1.00)
        breakingStyle.cellSwitchOffTintColor = UIColor(red:0.77, green:0.76, blue:0.75, alpha:1.00)
        breakingStyle.preferenceLabelFont = UIFont(name: "Avenir Next", size: 17)
        breakingStyle.preferenceLabelColor = UIColor(red:0.77, green:0.76, blue:0.75, alpha:1.00)
        breakingStyle.titleFont = UIFont(name: "AvenirNext-Medium", size: 20)
        breakingStyle.titleColor = UIColor(red:0.77, green:0.76, blue:0.75, alpha:1.00)
        
        UATagPreferenceCenter.start(preferences: [breakingLocal,
                                                  breakingSports,
                                                  breakingFinance,
                                                  breakingWeather],
                                    style: breakingStyle,
                                    title: "Breaking News Preferences")
        
    }
    
    // MARK: - View Setup
    
    @IBAction func copyChannelID(_ sender: Any) {
        UIPasteboard.general.string = UAirship.push().channelID
        
        let alertController = UIAlertController(title: "Copied", message: "Copied Channel ID to clipboard.", preferredStyle: .alert)
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func setup() {
        if UAirship.push().channelID != nil {
            self.breakingNewsButton.isEnabled = true
            self.generalNewsButton.isEnabled = true
            self.channelLabel.isHidden = false
            self.channelButton.isHidden = false
            self.channelButton.setTitle(UAirship.push().channelID, for: .normal)
            self.checkSubscriptions()
            
        } else {
            self.breakingNewsButton.isEnabled = false
            self.generalNewsButton.isEnabled = false
            self.channelLabel.isHidden = true
            self.channelButton.isHidden = true
        }
    }
    
    func checkSubscriptions() {
        self.breakingSubsTextView.text = self.createSubscriptionsString(tagName.breakingTagNames)
        self.generalSubsTextView.text = self.createSubscriptionsString(tagName.generalTagNames)
    }
    
    func createSubscriptionsString(_ list: [String]) -> String {
        let deviceTags = UAirship.push().tags
        
        var newsSubs = ""
        
        for tag in list {
            if deviceTags.contains(tag) {
                newsSubs += "\(self.getDisplayName(tag))\n"
            }
        }
        
        if newsSubs == "" {
            newsSubs = "No Subscriptions"
        }
        
        return newsSubs
    }
    
    func getDisplayName(_ tag: String) -> String {
        return NSLocalizedString(tag, tableName: "UITagNames", comment: "Tag Preference Label")
    }
}

