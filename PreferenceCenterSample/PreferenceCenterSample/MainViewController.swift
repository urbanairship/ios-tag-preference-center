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
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelButton: UIButton!
    @IBOutlet weak var breakingSubsTextView: UITextView!
    @IBOutlet weak var generalSubsTextView: UITextView!
    
    static let registeredChannelID = Notification.Name(rawValue: "registeredChannelID")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(MainViewController.setup),
            name: MainViewController.registeredChannelID,
            object: nil);
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
                                                    displayName: "All World News"))
            generalNewsPrefs.append(UATagPreference(tag: tagName.sports.rawValue,
                                                    displayName: "All Sports News"))
            generalNewsPrefs.append(UATagPreference(tag: tagName.finance.rawValue,
                                                    displayName: "All Financial News"))
            generalNewsPrefs.append(UATagPreference(tag: tagName.weather.rawValue,
                                                    displayName: "Weather Updates"))
            tagPrefVC.preferences = generalNewsPrefs
            tagPrefVC.style = UATagPreferencesStyle(contentsOfFile: "GeneralNewsPrefsStyle")
            
            tagPrefVC.title = "General News Preferences"
        }
    }
    
    // MARK: - Preparing the preference center for a modal view
    
    // this example styles the preference center directly
    @IBAction func showBreakingNewsPrefs(_ sender: Any) {
        let breakingLocal = UATagPreference(tag: tagName.breakingWorld.rawValue, displayName: "World News")
        let breakingSports = UATagPreference(tag: tagName.breakingSports.rawValue, displayName: "Sports Highlights")
        let breakingFinance = UATagPreference(tag: tagName.breakingFinance.rawValue, displayName: "Worldwide Financial News")
        let breakingWeather = UATagPreference(tag: tagName.breakingWeather.rawValue, displayName: "Major Weather Incidents")
        
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
        
        UATagPreferenceCenter.start(preferences: [breakingLocal, breakingSports, breakingFinance, breakingWeather], style: breakingStyle, title: "Breaking News Preferences")
    }
    
    // MARK: - View Setup
    
    @IBAction func enableNotifications(_ sender: Any) {
        if UAirship.shared() == nil {
            return
        }
        if !UAirship.push().userPushNotificationsEnabled {
            UAirship.push().userPushNotificationsEnabled = true
        }
    }
    
    @IBAction func copyChannelID(_ sender: Any) {
        UIPasteboard.general.string = UAirship.push().channelID
        let message = UAInAppMessage()
        message.alert = "Copied To Clipboard"
        message.position = UAInAppMessagePosition.bottom
        message.duration = 1.5
        message.primaryColor = UIColor(red:0.18, green:0.18, blue:0.18, alpha:1.00)
        message.secondaryColor = UIColor(red:0.77, green:0.76, blue:0.75, alpha:1.00)
        
        UAirship.inAppMessaging().display(message)
    }
    
    func setup() {
        if UAirship.shared() != nil {
            if UAirship.push().channelID != nil {
                self.breakingNewsButton.isEnabled = true
                self.generalNewsButton.isEnabled = true
                self.checkSubscriptions()
            }
            
            if UAirship.push().userPushNotificationsEnabled == true {
                self.notificationButton.isHidden = true
                self.channelLabel.isHidden = false
                self.channelButton.isHidden = false
            } else {
                self.notificationButton.isHidden = false
                self.channelLabel.isHidden = true
                self.channelButton.isHidden = true
            }
        } else {
            self.channelLabel.isHidden = true
            self.channelButton.isHidden = true
            self.breakingNewsButton.isEnabled = false
            self.generalNewsButton.isEnabled = false
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
                newsSubs += "\(self.getDisplayName(tag: tag))\n"
            }
        }
        
        if newsSubs == "" {
            newsSubs = "No Subscriptions"
        }
        
        return newsSubs
    }
    
    func getDisplayName(tag: String) -> String {
        switch tag {
        case tagName.breakingWorld.rawValue:
            return "World Events"
        case tagName.breakingSports.rawValue:
            return "Sports Highlights"
        case tagName.breakingFinance.rawValue:
            return "Financial Events"
        case tagName.breakingWeather.rawValue:
            return "Weather Incidents"
        case tagName.worldNews.rawValue:
            return "All News"
        case tagName.sports.rawValue:
            return "Sports News"
        case tagName.finance.rawValue:
            return "Financial News"
        case tagName.weather.rawValue:
            return "Weather Updates"
        default:
            return "Unknown Tag"
        }
    }
}

