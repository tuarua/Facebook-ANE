package com.tuarua.facebook {
public final class AccessTokenSource {
    /** Indicates an access token has not been obtained, or is otherwise invalid.*/
    public static const none:int = 0;
    /**
     * Indicates an access token was obtained by the user logging in through the
     * Facebook app for Android using the web login dialog.
     */
    public static const facebookApplicationWeb:int = 1;
    /**
     * Indicates an access token was obtained by the user logging in through the
     * Facebook app for Android using the native login dialog.
     */
    public static const facebookApplicationNative:int = 2;
    /**
     * Indicates an access token was obtained by asking the Facebook app for the
     * current token based on permissions the user has already granted to the app.
     * No dialog was shown to the user in this case.
     */
    public static const facebookApplicationService:int = 3;
    /**  Indicates an access token was obtained by the user logging in through the Web-based dialog.*/
    public static const webView:int = 4;
    /** Indicates an access token was obtained by the user logging in through the Web-based dialog on a Chrome Custom Tab. */
    public static const chromeCustomTab:int = 5;
    /** Indicates an access token is for a test user rather than an actual Facebook user. */
    public static const testUser:int = 6;
    /** Indicates an access token constructed with a Client Token. */
    public static const clientToken:int = 7;
    /** Indicates an access token constructed from facebook.com/device*/
    public static const deviceAuth:int = 8;
}
}
