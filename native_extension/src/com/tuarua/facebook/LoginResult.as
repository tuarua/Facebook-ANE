package com.tuarua.facebook {
public class LoginResult {
    /**
     * The new access token.
     */
    public var accessToken:AccessToken;
    /**
     * The recently granted permissions.
     */
    public var recentlyGrantedPermissions:Vector.<String> = new Vector.<String>();
    /**
     * The recently denied permissions.
     */
    public var recentlyDeniedPermissions:Vector.<String> = new Vector.<String>();

    public function LoginResult(data:Object) {
        accessToken = new AccessToken(data.accessToken);
        for each (var elem3:String in data.recentlyGrantedPermissions) recentlyGrantedPermissions.push(elem3);
        for each (var elem4:String in data.recentlyDeniedPermissions) recentlyDeniedPermissions.push(elem4);
    }
}
}