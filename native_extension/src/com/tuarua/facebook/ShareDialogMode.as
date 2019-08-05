/*
 *  Copyright 2019 Tua Rua Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.tuarua.facebook {
/** Modes for the ShareDialog. The automatic mode will progressively check the
 * availability of different modes and open the most
 * appropriate mode for the dialog that is available. iOS only */
public final class ShareDialogMode {
    /** Acts with the most appropriate mode that is available.*/
    public static const automatic:int = 0;
    /** Displays the dialog in the main native Facebook app.*/
    public static const native:int = 1;
    /** Displays the dialog in the iOS integrated share sheet.*/
    public static const shareSheet:int = 2;
    /** Displays the dialog in Safari.*/
    public static const browser:int = 3;
    /** Displays the dialog in a UIWebView within the app.*/
    public static const web:int = 4;
    /** Displays the feed dialog in Safari. */
    public static const feedBrowser:int = 5;
    /** Displays the feed dialog in a UIWebView within the app.*/
    public static const feedWeb:int = 6;
}
}
