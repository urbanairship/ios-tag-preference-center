### Sample App Setup

1. Run `pod install` from the `PreferenceCenterSample` folder.
2. Open the `PreferenceCenterSample` folder and remove `.sample` from the `AirshipConfig.plist.sample` file
3. Open the newly created `PreferenceCenterSample.xcworkspace` workspace and add the `AirshipConfig.plist` file to your project
4. Add your Urban Airship Development App Key and App Secret to the `AirshipConfig.plist` file.
5. Change the signing team and bundle identifier to match your app.
6. Ensure that push notifications have been enabled for your app bundle as detailed in our [APNS Setup](https://docs.urbanairship.com/platform/push-providers/apns/) document.
7. The sample app uses news preferences as a use case and allows you to select breaking and general news preferences. The Breaking news button sets up a modal example and the general news button segues into a view directly using a file for styling.