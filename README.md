# Facebook-ANE

Perform Facebook login and sharing with this Adobe Air Native Extension for iOS 9.0+ and Android 21+.   

-------------

## Android

#### The ANE + Dependencies

cd into /example and run:
- macOS (Terminal)
```shell
bash get_android_dependencies.sh
```
- Windows Powershell
```shell
PS get_android_dependencies.ps1
```

```xml
<extensions>
<extensionID>com.tuarua.frekotlin</extensionID>
<extensionID>com.google.code.gson.gson</extensionID>
<extensionID>androidx.legacy.legacy-support-v4</extensionID>
<extensionID>androidx.appcompat.appcompat</extensionID>
<extensionID>androidx.cardview.cardview</extensionID>
<extensionID>androidx.browser.browser</extensionID>
<extensionID>com.parse.bolts.bolts-android</extensionID>
<extensionID>com.facebook.android.facebook-android-sdk</extensionID>
<extensionID>com.tuarua.FacebookANE</extensionID>
...
</extensions>
```

You will also need to include the following in your app manifest. Update accordingly.

```xml
<uses-sdk android:minSdkVersion="19" android:targetSdkVersion="28" />
<application>
    ...
    <activity android:name="com.facebook.FacebookActivity" android:configChanges="keyboard|keyboardHidden|screenLayout|screenSize|orientation" android:theme="@android:style/Theme.Translucent.NoTitleBar" android:label="@string/app_name" />
    <activity android:name="com.facebook.CustomTabMainActivity" />
    <activity android:name="com.facebook.CustomTabActivity" android:exported="true" >
        <intent-filter>
            <action android:name="android.intent.action.VIEW" />
            <category android:name="android.intent.category.DEFAULT" />
            <category android:name="android.intent.category.BROWSABLE" />
            <data android:scheme="fb[FACEBOOK_APP_ID]" />
        </intent-filter>
    </activity>
    <meta-data android:name="com.facebook.sdk.AutoLogAppEventsEnabled" android:value="true"/>
    <meta-data android:name="com.facebook.sdk.AdvertiserIDCollectionEnabled" android:value="false"/>
    <meta-data android:name="com.facebook.sdk.ApplicationId" android:value="\ [FACEBOOK_APP_ID]"/>
    <provider android:authorities="com.facebook.app.FacebookContentProvider[FACEBOOK_APP_ID]" android:name="com.facebook.FacebookContentProvider" android:exported="true" />
</application>
```

-------------

## iOS

#### The ANE + Dependencies

N.B. You must use a Mac to build an iOS app using this ANE. Windows is NOT supported.

From the command line cd into /example and run:

```shell
bash get_ios_dependencies.sh
```

This folder, ios_dependencies/device/Frameworks, must be packaged as part of your app when creating the ipa. How this is done will depend on the IDE you are using.
After the ipa is created unzip it and confirm there is a "Frameworks" folder in the root of the .app package.   

-------------

You will also need to include the following in your app manifest. Update accordingly.
```xml
<InfoAdditions><![CDATA[            
<key>MinimumOSVersion</key>
<string>9.0</string>
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>fb[FACEBOOK_APP_ID]</string>
    </array>
  </dict>
</array>
<key>FacebookAppID</key>
<string>[FACEBOOK_APP_ID]</string>
<key>FacebookDisplayName</key>
<string>[MY_APP_NAME]</string>
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>fbapi</string>
  <string>fb-messenger-share-api</string>
  <string>fbauth2</string>
  <string>fbshareextension</string>
</array>
<key>FacebookAutoLogAppEventsEnabled</key>
<true/> <!-- or false -->
<key>FacebookAdvertiserIDCollectionEnabled</key>
<true/> <!-- or false -->
]]></InfoAdditions>
```

### Prerequisites

You will need:

- IntelliJ IDEA
- AIR 33.0.2.338+
- Xcode 11.3
- wget on macOS via `brew install wget`
- Powershell on Windows
- Android Studio 3 if you wish to edit the Android source

### References
* [https://developers.facebook.com/docs/facebook-login/android]
* [https://developers.facebook.com/docs/swift] 
