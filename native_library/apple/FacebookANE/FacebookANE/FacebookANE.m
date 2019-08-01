/* Copyright 2019 Tua Rua Ltd.
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "FreMacros.h"
#import "FacebookANE_oc.h"
#import <FacebookANE_FW/FacebookANE_FW.h>

#define FRE_OBJC_BRIDGE TRFBS_FlashRuntimeExtensionsBridge
@interface FRE_OBJC_BRIDGE : NSObject<FreSwiftBridgeProtocol>
@end
@implementation FRE_OBJC_BRIDGE {
}
FRE_OBJC_BRIDGE_FUNCS
@end

@implementation FacebookANE_LIB
SWIFT_DECL(TRFBS)
CONTEXT_INIT(TRFBS) {
    SWIFT_INITS(TRFBS)
    
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRFBS, init)
        ,MAP_FUNCTION(TRFBS, createGUID)
        ,MAP_FUNCTION(TRFBS, setIsDebugEnabled)
        ,MAP_FUNCTION(TRFBS, addLoggingBehavior)
        ,MAP_FUNCTION(TRFBS, removeLoggingBehavior)
        ,MAP_FUNCTION(TRFBS, clearLoggingBehaviors)
        ,MAP_FUNCTION(TRFBS, isLoggingBehaviorEnabled)
        ,MAP_FUNCTION(TRFBS, getLimitEventAndDataUsage)
        ,MAP_FUNCTION(TRFBS, setLimitEventAndDataUsage)
        ,MAP_FUNCTION(TRFBS, isDebugEnabled)
        ,MAP_FUNCTION(TRFBS, getHashKey)
        ,MAP_FUNCTION(TRFBS, isInitialized)
        ,MAP_FUNCTION(TRFBS, login)
        ,MAP_FUNCTION(TRFBS, logout)
        ,MAP_FUNCTION(TRFBS, getLoginBehavior)
        ,MAP_FUNCTION(TRFBS, setLoginBehavior)
        ,MAP_FUNCTION(TRFBS, getDefaultAudience)
        ,MAP_FUNCTION(TRFBS, setDefaultAudience)
        ,MAP_FUNCTION(TRFBS, getCurrentAccessToken)
        ,MAP_FUNCTION(TRFBS, refreshCurrentAccessTokenAsync)
        ,MAP_FUNCTION(TRFBS, isCurrentAccessTokenActive)
        ,MAP_FUNCTION(TRFBS, isDataAccessActive)
        ,MAP_FUNCTION(TRFBS, share)
    };
    
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRFBS) {
    [TRFBS_swft dispose];
    TRFBS_swft = nil;
    TRFBS_freBridge = nil;
    TRFBS_swftBridge = nil;
    TRFBS_funcArray = nil;
}
EXTENSION_INIT(TRFBS)
EXTENSION_FIN(TRFBS)
@end
