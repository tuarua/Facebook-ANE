package com.tuarua.facebook {
import com.tuarua.FacebookANEContext;
import com.tuarua.fre.ANEError;

public class AccessToken {
    private static var _token:String;
    private static var _userId:String;
    private static var _applicationId:String;
    private static var _source:int;
    private static var _expires:Date;
    private static var _lastRefresh:Date;
    private static var _dataAccessExpirationTime:Date;
    private static var _declinedPermissions:Vector.<String> = new Vector.<String>();
    private static var _expiredPermissions:Vector.<String> = new Vector.<String>();
    private static var _permissions:Vector.<String> = new Vector.<String>();

    public function AccessToken(data:Object = null) {
        if (data == null) return;
        _token = data["token"];
        _userId = data["userId"];
        _applicationId = data["applicationId"];
        _source = data["source"];
        var expires:Number = data["expires"];
        var lastRefresh:Number = data["lastRefresh"];
        var dataAccessExpirationTime:Number = data["dataAccessExpirationTime"];
        _expires = new Date(expires);
        _lastRefresh = new Date(lastRefresh);
        _dataAccessExpirationTime = new Date(dataAccessExpirationTime);
        for each (var elem0:String in data["declinedPermissions"]) _declinedPermissions.push(elem0);
        for each (var elem1:String in data["expiredPermissions"]) _expiredPermissions.push(elem1);
        for each (var elem2:String in data["permissions"]) _permissions.push(elem2);
        _expiredPermissions = new <String>[data["expiredPermissions"]];
        _permissions = new <String>[data["permissions"]];
    }

    public static function getCurrentAccessToken():AccessToken {
        var theRet:* = FacebookANEContext.context.call("getCurrentAccessToken");
        if (theRet is ANEError) throw theRet as ANEError;
        var ret:AccessToken = new AccessToken(JSON.parse(theRet as String));
        return ret;
    }

    public static function refreshCurrentAccessTokenAsync(onTokenRefreshed:Function, onTokenRefreshFailed:Function):void {
        var theRet:* = FacebookANEContext.context.call("refreshCurrentAccessTokenAsync",
                FacebookANEContext.createEventId(onTokenRefreshed), FacebookANEContext.createEventId(onTokenRefreshFailed));
        if (theRet is ANEError) throw theRet as ANEError;
    }

    public static function get isCurrentAccessTokenActive():Boolean {
        var theRet:* = FacebookANEContext.context.call("isCurrentAccessTokenActive");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    public static function get isDataAccessActive():Boolean {
        var theRet:* = FacebookANEContext.context.call("isDataAccessActive");
        if (theRet is ANEError) throw theRet as ANEError;
        return theRet as Boolean;
    }

    public function get token():String {
        return _token;
    }

    public function get userId():String {
        return _userId;
    }

    public function get applicationId():String {
        return _applicationId;
    }

    public function get source():int {
        return _source;
    }

    public function set source(value:int):void {
        _source = value;
    }

    public function set token(value:String):void {
        _token = value;
    }

    public function get expires():Date {
        return _expires;
    }

    public function set expires(value:Date):void {
        _expires = value;
    }

    public function get lastRefresh():Date {
        return _lastRefresh;
    }

    public function set lastRefresh(value:Date):void {
        _lastRefresh = value;
    }

    public function get dataAccessExpirationTime():Date {
        return _dataAccessExpirationTime;
    }

    public function set dataAccessExpirationTime(value:Date):void {
        _dataAccessExpirationTime = value;
    }

    public function get declinedPermissions():Vector.<String> {
        return _declinedPermissions;
    }

    public function set declinedPermissions(value:Vector.<String>):void {
        _declinedPermissions = value;
    }

    public function get expiredPermissions():Vector.<String> {
        return _expiredPermissions;
    }

    public function set expiredPermissions(value:Vector.<String>):void {
        _expiredPermissions = value;
    }

    public function get permissions():Vector.<String> {
        return _permissions;
    }

    public function set permissions(value:Vector.<String>):void {
        _permissions = value;
    }

    public function set userId(userId:String):void {
        _userId = userId;
    }

    public function set applicationId(applicationId:String):void {
        _applicationId = applicationId;
    }
}
}