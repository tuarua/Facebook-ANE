package {

import com.tuarua.FacebookANE;
import com.tuarua.facebook.AccessToken;
import com.tuarua.facebook.AccessTokenSource;
import com.tuarua.facebook.FacebookError;
import com.tuarua.facebook.LoginBehavior;
import com.tuarua.facebook.LoginManager;
import com.tuarua.facebook.LoginResult;

import flash.desktop.NativeApplication;
import flash.events.Event;

import starling.display.Sprite;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.utils.Align;

import views.SimpleButton;

public class StarlingRoot extends Sprite {
    private var btnLogin:SimpleButton = new SimpleButton("Login");
    private var btnGetAccessToken:SimpleButton = new SimpleButton("Get Access Token");
    private var btnRefreshToken:SimpleButton = new SimpleButton("Refresh Token");
    private var btnLogout:SimpleButton = new SimpleButton("Logout");
    private var loginManager:LoginManager;
    private var statusLabel:TextField;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        FacebookANE.init("2861959030739282", onCurrentAccessTokenChanged);
        FacebookANE.isDebugEnabled = true;
        trace("FacebookANE.isInitialized:", FacebookANE.isInitialized);
        if (!FacebookANE.isInitialized) return;
        trace("hashKey:", FacebookANE.hashKey);
        initMenu();
    }

    private function initMenu():void {
        btnLogin.x = (stage.stageWidth - 200) * 0.5;
        btnLogin.y = 25;
        btnLogin.addEventListener(TouchEvent.TOUCH, onLoginClick);

        btnRefreshToken.x = (stage.stageWidth - 200) * 0.5;
        btnRefreshToken.y = btnLogin.y + 75;
        btnRefreshToken.addEventListener(TouchEvent.TOUCH, onRefreshTokenClick);
        btnRefreshToken.visible = false;

        btnGetAccessToken.x = (stage.stageWidth - 200) * 0.5;
        btnGetAccessToken.y = btnRefreshToken.y + 75;
        btnGetAccessToken.addEventListener(TouchEvent.TOUCH, onGetAccessTokenClick);
        btnGetAccessToken.visible = false;

        btnLogout.x = (stage.stageWidth - 200) * 0.5;
        btnLogout.y = btnGetAccessToken.y + 75;
        btnLogout.addEventListener(TouchEvent.TOUCH, onLogoutClick);
        btnLogout.visible = false;

        addChild(btnLogin);
        addChild(btnRefreshToken);
        addChild(btnGetAccessToken);
        addChild(btnLogout);

        statusLabel = new TextField(stage.stageWidth, 400, "");
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnLogout.y + 75;
        addChild(statusLabel);

    }

    private function onGetAccessTokenClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnGetAccessToken);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            var accessToken:AccessToken = AccessToken.getCurrentAccessToken();
            trace("isCurrentAccessTokenActive:", AccessToken.isCurrentAccessTokenActive);
            trace("token:", accessToken.token);
            trace("userId:", accessToken.userId);
            trace("applicationId:", accessToken.applicationId);
            switch (accessToken.source) {
                case 0:
                    trace("source:", "NONE");
                    break;
                case 1:
                    trace("source:", "FACEBOOK_APPLICATION_WEB");
                    break;
                case 2:
                    trace("source:", "FACEBOOK_APPLICATION_NATIVE");
                    break;
                case 3:
                    trace("source:", "FACEBOOK_APPLICATION_SERVICE");
                    break;
                case 4:
                    trace("source:", "WEB_VIEW");
                    break;
                case 5:
                    trace("source:", "CHROME_CUSTOM_TAB");
                    break;
                case 6:
                    trace("source:", "TEST_USER");
                    break;
                case 7:
                    trace("source:", "CLIENT_TOKEN");
                    break;
                case 8:
                    trace("source:", "DEVICE_AUTH");
                    break;
                default:
                    break;
            }
            trace("expires:", accessToken.expires);
            trace("lastRefresh:", accessToken.lastRefresh);
            trace("permissions:", accessToken.permissions);

            if (accessToken.token != null) {
                statusLabel.text = "Token: " + accessToken.token;
            }
        }
    }

    private function onLoginClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLogin);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            loginManager = FacebookANE.loginManager;
            var permissions:Vector.<String> = new <String>["public_profile", "email"];
            loginManager.loginBehavior = LoginBehavior.NATIVE_WITH_FALLBACK;
            loginManager.login(permissions, onLoginSuccess, onLoginCancel, onLoginError);
        }
    }

    private function onRefreshTokenClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnRefreshToken);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            AccessToken.refreshCurrentAccessTokenAsync(onTokenRefreshed, onTokenRefreshedFailed);
        }
    }

    private function onLogoutClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnLogout);
        if (touch != null && touch.phase == TouchPhase.ENDED) {
            loginManager.logout();
            btnGetAccessToken.visible = btnLogout.visible = btnRefreshToken.visible = false;
            statusLabel.text = "Logged out";
        }
    }

    private function onLoginError(error:FacebookError):void {
        trace("onLoginError");
        statusLabel.text = "Error: " + error.message;
    }

    private function onLoginCancel():void {
        trace("onLoginCancel");
        statusLabel.text = "Login Cancelled";
    }

    private function onLoginSuccess(loginResult:LoginResult):void {
        trace("onLoginSuccess");
        btnGetAccessToken.visible = btnLogout.visible = btnRefreshToken.visible = true;
        statusLabel.text = "Login Success \n";
        trace(loginResult.accessToken.token);
    }

    private function onCurrentAccessTokenChanged(oldToken:AccessToken, newToken:AccessToken):void {
        trace("onCurrentAccessTokenChanged");
        statusLabel.text = "Current Access Token Changed: \n";
        statusLabel.text += "Old: " + oldToken.token + "\n";
        statusLabel.text += "New: " + newToken.token + "\n";
    }

    private function onTokenRefreshed(accessToken:AccessToken):void {
        trace("onTokenRefreshed");
        statusLabel.text = "Token Refreshed: " + accessToken.token;
    }

    private function onTokenRefreshedFailed(error:FacebookError):void {
        trace("onTokenRefreshedFailed");
        statusLabel.text = "Error: " + error.message;
    }

    private function onExiting(event:Event):void {
        FacebookANE.dispose();
    }

}
}