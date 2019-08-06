#!/bin/sh

AneVersion="1.0.0"
FreKotlinVersion="1.8.0"
GsonVersion="2.8.4"
SupportV4Version="27.1.0"
LifeCycleVersion="1.1.1"
BoltsVersion="1.4.0"
FacebookVersion="5.1.0"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion.ane?raw=true
wget -O android_dependencies/com.android.support.support-v4-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.support-v4-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.android.support.appcompat-v7-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.appcompat-v7-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.android.support.cardview-v7-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.cardview-v7-$SupportV4Version.ane?raw=true
wget -O android_dependencies/com.android.support.customtabs-$SupportV4Version.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/support/com.android.support.customtabs-$SupportV4Version.ane?raw=true
wget -O android_dependencies/android.arch.lifecycle.runtime-$LifeCycleVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/play-services/android.arch.lifecycle.runtime-$LifeCycleVersion.ane?raw=true
wget -O android_dependencies/com.parse.bolts.bolts-android-$BoltsVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/facebook/com.parse.bolts.bolts-android-$BoltsVersion.ane?raw=true
wget -O android_dependencies/com.facebook.android.facebook-android-sdk-$FacebookVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/facebook/com.facebook.android.facebook-android-sdk-$FacebookVersion.ane?raw=true
wget -O ../native_extension/ane/FacebookANE.ane https://github.com/tuarua/Facebook-ANE/releases/download/${AneVersion}/FacebookANE.ane?raw=true
