#!/bin/sh

AneVersion="1.2.0"
FreKotlinVersion="1.9.5"
GsonVersion="2.8.6"
SupportV4Version="1.0.0"
BoltsVersion="1.4.0"
FacebookVersion="5.13.0"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/androidx.legacy.legacy-support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.legacy.legacy-support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/androidx.appcompat.appcompat-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.appcompat.appcompat-$SupportV4Version.ane?raw=true
wget -O android_dependencies/androidx.cardview.cardview-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.cardview.cardview-$SupportV4Version.ane?raw=true
wget -O android_dependencies/androidx.browser.browser-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/androidx.browser.browser-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.parse.bolts.bolts-android-$BoltsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/facebook/com.parse.bolts.bolts-android-$BoltsVersion.ane?raw=true
wget -O android_dependencies/com.facebook.android.facebook-android-sdk-$FacebookVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/facebook/com.facebook.android.facebook-android-sdk-$FacebookVersion.ane?raw=true
wget -O ../native_extension/ane/FacebookANE.ane https://github.com/tuarua/Facebook-ANE/releases/download/${AneVersion}/FacebookANE.ane?raw=true
