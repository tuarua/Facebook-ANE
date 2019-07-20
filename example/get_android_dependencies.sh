#!/bin/sh

AneVersion="1.0.0"
FreKotlinVersion="1.8.0"
GsonVersion="2.8.4"

wget -O android_dependencies/com.tuarua.frekotlin-$FreKotlinVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/kotlin/com.tuarua.frekotlin-$FreKotlinVersion.ane?raw=true
wget -O android_dependencies/com.google.code.gson.gson-$GsonVersion.ane https://github.com/tuarua/Android-ANE-Dependencies/blob/master/anes/misc/com.google.code.gson.gson-$GsonVersion-air33.ane?raw=true
wget -O ../native_extension/ane/FacebookANE.ane https://github.com/tuarua/Facebook-ANE/releases/download/${AneVersion}/FacebookANE.ane?raw=true
