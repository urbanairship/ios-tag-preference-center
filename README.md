# ios-tag-preference-center
## What is this?
A native out of the box preference center that presents the user with a list of preferences that, when selected, create tags.

## Requirements

Xcode 8.0+ is required for all projects and the SDK. Projects must target >= iOS8.

### Installation

Make sure you have the [CocoaPods](http://cocoapods.org) dependency manager installed. You can do so by executing the following command:

```sh
$ gem install cocoapods
```

Specify the UrbanAirship-iOS-Tag-Preference-Center in your podfile with the use_frameworks! option. This pod also requires the UrbanAirship-iOS-SDK which will be added automatically if you have not already implemented it:

```txt
use_frameworks!

# Urban Airship SDK
target "<Your Target Name>" do
	pod ‘UrbanAirship-iOS-Tag-Preference-Center’
end
```

Install using the following command:

```sh
$ pod install
```

**Sample App**
A sample app is included. Setup instructions can be found [here](https://github.com/urbanairship/ios-tag-preference-center/blob/master/PreferenceCenterSample).

## Usage
**Important** - The Tag Preference Center relies on the Urban Airship SDK in order to work. Before going further, please ensure that the SDK has been fully implemented with your app by following our [Getting Started Guide](http://docs.urbanairship.com/platform/ios.html#getting-started).

First, import `UATagPreferenceCenter` 

```swift
import UATagPreferenceCenter
```

You’ll then want to define your preferences. Each preference consists of an internal tag and the corresponding display name. Use `UATagPreference` for this:
```swift
let financePref = UATagPreference(tag: "sportsPref", displayName: "Sport")
let sportsPref = UATagPreference(tag: "financePref", displayName: "Finance")
let worldNewsPref = UATagPreference(tag: "worldNewsPref", displayName: "World News")
let weatherPref = UATagPreference(tag: "weatherPref", displayName: "Weather")
```

By default, tags will be stored on the device, however, you also have the option to use any existing tag groups that you have created for preferences. This gives you further flexibility for altering tag preferences outside of the app:
```swift
let financePref = UATagPreference(tag: "sportsPref", displayName: "Sport", tagGroup: "uaPreferences")
let sportsPref = UATagPreference(tag: "financePref", displayName: "Finance", tagGroup: "uaPreferences")
let worldNewsPref = UATagPreference(tag: "worldNewsPref", displayName: "World News", tagGroup: "uaPreferences")
let weatherPref = UATagPreference(tag: "weatherPref", displayName: "Weather", tagGroup: "uaPreferences")
```

Start the preference center with your preferences. Also include a title to be shown then the view displays:
```swift
UATagPreferences.start(preferences: [financePref,
                                     sportsPref,
                                     worldNewsPref,
                                     weatherPref],
                       title: "News Preferences")
```

This will display a preference center with the list of preferences you passed through to it, along with a switch for each preference indicating whether or not the device includes the preference tag.

**Styling the Preference Center**

![alt tag](https://github.com/urbanairship/ios-tag-preference-center/blob/master/readmeAssets/preferenceCenterImage.png)

1. `closeButtonFont` & `closeButtonColor`
2. `backgroundColor`
3. `titleFont` & `titleColor`
4. `preferenceLabelFont` & `preferenceLabelColor`
5. `cellSwitchOnColor`
6. `cellSwitchOffTintColor`
7. `cellBackgroundColor`
8. `cellSeparatorColor`
9. `listColor`

If you don’t want to use the default preference center stylings, you can include your own:
```swift
let myStyle = UATagPreferencesStyle()
        
myStyle.preferenceLabelFont = UIFont(name: "Avenir Next", size: 17)
myStyle.preferenceLabelColor = UIColor(red:0.87, green:0.64, blue:0.23, alpha:1.00)
myStyle.closeButtonColor = UIColor(red:0.44, green:0.40, blue:0.85, alpha:1.00)
```

All styles are accessible:
```swift
myStyle.cellBackgroundColor = UIColor(red:0.92, green:0.85, blue:1.00, alpha:1.00)
myStyle.listColor = UIColor(red:0.92, green:0.85, blue:1.00, alpha:1.00)
myStyle.backgroundColor = UIColor(red:0.92, green:0.85, blue:1.00, alpha:1.00)
myStyle.cellSeparatorColor = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.00)
myStyle.cellSwitchOnColor = UIColor(red:0.44, green:0.40, blue:0.85, alpha:1.00)
myStyle.cellSwitchOffTintColor = UIColor(red:0.44, green:0.40, blue:0.85, alpha:1.00)
```

Include your custom style when starting the preference center:
```swift
UATagPreferences.start(preferences: [financePref,
                                     sportsPref,
                                     worldNewsPref,
                                     weatherPref],
                       style: myStyle,
                       title: "News Preferences")
```

If you would like to use a plist file to load your custom style:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>preferenceLabelFont</key>
        <dict>
            <key>fontName</key>
            <string>Avenir Next</string>
            <key>fontSize</key>
            <string>17</string>
        </dict>

        <key>preferenceLabelColor</key>
        <string>#4F758F</string>
        
        <key>closeButtonColor</key>
        <string>#4F758F</string>
        
    </dict>
</plist>

```

Set your plist file with:
```swift
let myStyle = UATagPreferencesStyle(contentsOfFile: "MyStylePreferences")
```

A default `UATagPreferenceCenterStyle.plist` file is included and can be overwritten with custom styles.

A  `UATagPreferences` instance can also be used to set up and style your preference center:
```swift
let prefCenter = UATagPreferences(preferences: [financePref,
                                                sportsPref,
                                                worldNewsPref,
                                                weatherPref])

let myStyle = UATagPreferencesStyle()
        
myStyle.preferenceLabelFont = UIFont(name: "Avenir Next", size: 17)
myStyle.preferenceLabelColor = UIColor(red:0.87, green:0.64, blue:0.23, alpha:1.00)
myStyle.closeButtonColor = UIColor(red:0.44, green:0.40, blue:0.85, alpha:1.00)

prefCenter.style = myStyle
prefCenter.title = "News Preferences"
prefCenter.start()
```

**Note:** The preference center can be saved and updated outside of the app. It’s important to consider whether or not to allow any newer preferences to override your default values. Each call to open the preference center has an optional `preferSavedPreferences` parameter which defaults to `true` but will ignore saved preferences if set to `false`:

```swift
UATagPreferences.start(preferences: [financePref,
                                     sportsPref,
                                     worldNewsPref,
                                     weatherPref],
                       title: "News Preferences",
                       preferSavedPreferences: false)
```

when using a `UATagPreferences` instance:

```swift
prefCenter.start(preferSavedPreferences: false)
```

## Handling the Preference Center Through Push Notifications
If you would like send push notifications to update or open the preference center, turn this on after calling takeOff in your AppDelegate:

```swift
UAirship.takeOff(config)

// create a preference action after takeOff
UATagPreferences.registerAction()
```

You can also set a default `UATagPreferencesStyle` to use:

```swift
let myStyle = UATagPreferencesStyle()
        
myStyle.preferenceLabelFont = UIFont(name: "Avenir Next", size: 17)
myStyle.preferenceLabelColor = UIColor(red:0.87, green:0.64, blue:0.23, alpha:1.00)
myStyle.closeButtonColor = UIColor(red:0.44, green:0.40, blue:0.85, alpha:1.00)
        
UATagPreferences.registerAction(style: myStyle)
```

## Triggering a One-Off Preference Center From a Push Notification

To trigger the preference center from a push notification, include the action key `"ua_tag_preference_open_action"` along with a JSON payload. The same parameters apply as they did when setting up each `UATagPreference`:

```json
{
	"preferences": [
		{
    		"tag": "sportsPref", 
    		"displayName": "Sport",
		    "tagGroup": "uaPreferences"
		},
		{
		    "tag": "financePref", 
		    "displayName": "Finance",
		    "tagGroup": "uaPreferences"
		},
		{
		    "tag": "worldNewsPref", 
		    "displayName": "World News",
		    "tagGroup": "uaPreferences"
		},
		{
		    "tag": "weatherPref", 
		    "displayName": "Weather",
		    "tagGroup": "uaPreferences"
		}
	],
	"title": "News Preferences"
}
```

Full API cURL Example:

```curl
curl -X POST -H "Content-Type: application/json" -H "Accept: application/vnd.urbanairship+json; version=3;" -H "Authorization: Basic <AUTHORIZATION>" -d '{
    "audience":  "all",
    "device_types" : ["ios"],
    "notification" : { 
        "ios": {
          "alert": "Pick your favorite news preferences!"
        },
        "actions": {
			"app_defined": {
				"ua_tag_preference_open_action": {
					"preferences": [
						{
				    		"tag": "sportsPref", 
				    		"displayName": "Sport",
						    "tagGroup": "uaPreferences"
						},
						{
						    "tag": "financePref", 
						    "displayName": "Finance",
						    "tagGroup": "uaPreferences"
						},
						{
						    "tag": "worldNewsPref", 
						    "displayName": "World News",
						    "tagGroup": "uaPreferences"
						},
						{
						    "tag": "weatherPref", 
						    "displayName": "Weather",
						    "tagGroup": "uaPreferences"
						}
					],
					"title": "News Preferences"
				}
			}
		}
    }
}' "https://go.urbanairship.com/api/push"
```

## Updating the Preference Center From a Push Notification
You can update all or part of the preference center with the same key/value pairs as mentioned above. The only difference is the action key used, which is `ua_tag_preference_save_action`. It is recommended that you update through content-available silent pushes to avoid alerting the users unnecessarily.
