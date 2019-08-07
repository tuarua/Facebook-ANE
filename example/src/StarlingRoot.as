package {

import com.tuarua.FacebookSdk;
import com.tuarua.facebook.AccessToken;
import com.tuarua.facebook.DefaultAudience;
import com.tuarua.facebook.FacebookError;
import com.tuarua.facebook.LoggingBehavior;
import com.tuarua.facebook.LoginBehavior;
import com.tuarua.facebook.LoginManager;
import com.tuarua.facebook.LoginResult;
import com.tuarua.facebook.Permission;
import com.tuarua.facebook.ShareDialog;
import com.tuarua.facebook.ShareLinkContent;
import com.tuarua.facebook.SharePhoto;
import com.tuarua.facebook.SharePhotoContent;
import com.tuarua.facebook.ShareVideo;
import com.tuarua.facebook.ShareVideoContent;

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
    private var btnShare:SimpleButton = new SimpleButton("Share Link Content");
    private var loginManager:LoginManager;
    private var statusLabel:TextField;

    public function StarlingRoot() {
        TextField.registerCompositor(Fonts.getFont("fira-sans-semi-bold-13"), "Fira Sans Semi-Bold 13");
        NativeApplication.nativeApplication.addEventListener(Event.EXITING, onExiting);
    }

    public function start():void {
        trace("FacebookSdk.sdkVersion", FacebookSdk.sdkVersion);
        FacebookSdk.init("2861959030739282", onCurrentAccessTokenChanged);
        FacebookSdk.isDebugEnabled = true;
        trace("FacebookSdk.isInitialized:", FacebookSdk.isInitialized);
        if (!FacebookSdk.isInitialized) return;
        trace("FacebookSdk.hashKey:", FacebookSdk.hashKey);

        FacebookSdk.onShareSuccess = onShareSuccess;
        FacebookSdk.onShareCancel = onShareCancel;
        FacebookSdk.onShareError = onShareError;

        initMenu();
    }

    private function initMenu():void {
        btnShare.x = (stage.stageWidth - 200) * 0.5;
        btnShare.y = 25;
        btnShare.addEventListener(TouchEvent.TOUCH, onShareLinkClick);

        btnLogin.x = (stage.stageWidth - 200) * 0.5;
        btnLogin.y = btnShare.y + 75;
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

        addChild(btnShare);
        addChild(btnLogin);
        addChild(btnRefreshToken);
        addChild(btnGetAccessToken);
        addChild(btnLogout);

        statusLabel = new TextField(stage.stageWidth - 20, 400, "");
        statusLabel.x = 10;
        statusLabel.format.setTo(Fonts.NAME, 13, 0x222222, Align.LEFT, Align.TOP);
        statusLabel.touchable = false;
        statusLabel.y = btnLogout.y + 75;
        addChild(statusLabel);

    }

    private function onShareLinkClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShare);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

            var shareLinkContent:ShareLinkContent = new ShareLinkContent();
            shareLinkContent.contentUrl = "https://www.google.com";

            var shareDialog:ShareDialog = new ShareDialog(shareLinkContent);
            if (shareDialog.canShow) {
                shareDialog.show();
            } else {
                statusLabel.text = "Can't share Link";
            }

        }
    }

    private function onSharePhotoClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShare);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

            var sharePhotoContent:SharePhotoContent = new SharePhotoContent();
            var sharePhoto:SharePhoto = new SharePhoto();
            sharePhoto.imageUrl = "https://www.wired.com/wp-content/uploads/2014/07/Apple_Swift_Logo.png";
            sharePhotoContent.photos.push(sharePhoto);

            var shareDialog:ShareDialog = new ShareDialog(sharePhotoContent);
            if (shareDialog.canShow) {
                shareDialog.show();
            } else {
                statusLabel.text = "Can't share Photo";
            }
        }
    }

    private function onShareVideoClick(event:TouchEvent):void {
        var touch:Touch = event.getTouch(btnShare);
        if (touch != null && touch.phase == TouchPhase.ENDED) {

            var shareVideoContent:ShareVideoContent = new ShareVideoContent();
            var sharePhoto:ShareVideo = new ShareVideo();
            sharePhoto.videoUrl = "https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_10mb.mp4";
            shareVideoContent.video = sharePhoto;

            var shareDialog:ShareDialog = new ShareDialog(shareVideoContent);
            if (shareDialog.canShow) {
                shareDialog.show();
            } else {
                statusLabel.text = "Can't share Video";
            }
        }
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
                    trace("source:", "none");
                    break;
                case 1:
                    trace("source:", "facebookApplicationWeb");
                    break;
                case 2:
                    trace("source:", "facebookApplicationNative");
                    break;
                case 3:
                    trace("source:", "facebookApplicationService");
                    break;
                case 4:
                    trace("source:", "webView");
                    break;
                case 5:
                    trace("source:", "chromeCustomTab");
                    break;
                case 6:
                    trace("source:", "testUser");
                    break;
                case 7:
                    trace("source:", "clientToken");
                    break;
                case 8:
                    trace("source:", "deviceAuth");
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
            loginManager = FacebookSdk.loginManager;
            var permissions:Vector.<String> = new <String>[Permission.publicProfile, Permission.email];
            loginManager.loginBehavior = LoginBehavior.nativeWithFallback;
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
        statusLabel.text = "Error: " + error.message;
    }

    private function onLoginCancel():void {
        statusLabel.text = "Login Cancelled";
    }

    private function onLoginSuccess(loginResult:LoginResult):void {
        btnGetAccessToken.visible = btnLogout.visible = btnRefreshToken.visible = true;
        statusLabel.text = "Login Success \n";
        trace(loginResult.accessToken.token);
        trace(loginResult.accessToken.lastRefresh);
        trace(loginResult.accessToken.expires);
    }

    private function onShareError(error:FacebookError):void {
        statusLabel.text = "Error: " + error.message;
    }

    private function onShareCancel():void {
        statusLabel.text = "Share Cancelled";
    }

    private function onShareSuccess(postId:String):void {
        statusLabel.text = "Share Success";
        trace("postId:", postId);
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
        FacebookSdk.dispose();
    }

}
}