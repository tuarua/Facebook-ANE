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
public final class LoggingBehavior {
    /**
     * Indicates that HTTP requests and a summary of responses should be logged.
     */
    public static const REQUESTS:int = 0;
    /**
     * Indicates that access tokens should be logged as part of the request logging; normally they
     * are not.
     */
    public static const INCLUDE_ACCESS_TOKENS:int = 1;
    /**
     * Indicates that the entire raw HTTP response for each request should be logged.
     */
    public static const INCLUDE_RAW_RESPONSES:int = 2;
    /**
     * Indicates that cache operations should be logged.
     */
    public static const CACHE:int = 3;
    /**
     * Indicates the App Events-related operations should be logged.
     */
    public static const APP_EVENTS:int = 4;
    /**
     * Indicates that likely developer errors should be logged.  (This is set by default in
     * LoggingBehavior.)
     */
    public static const DEVELOPER_ERRORS:int = 5;
    /**
     * Log debug warnings from API response, e.g. when friends fields requested, but user_friends
     * permission isn't granted.
     */
    public static const GRAPH_API_DEBUG_WARNING:int = 6;
    /**
     * Log warnings from API response, e.g. when requested feature will be deprecated in next
     * version of API. Info is the lowest level of severity, using it will result in logging all
     * GRAPH_API_DEBUG levels.
     */
    public static const GRAPH_API_DEBUG_INFO:int = 7;
}
}