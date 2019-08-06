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
public final class DefaultAudience {
    /**
     * Represents an invalid default audience value, can be used when only reading.
     */
    public static const none:int = 0;
    /**
     * Indicates only the user is able to see posts made by the application.
     */
    public static const onlyMe:int = 1;
    /**
     * Indicates that the user's friends are able to see posts made by the application.
     */
    public static const friends:int = 2;
    /**
     * Indicates that all Facebook users are able to see posts made by the application.
     */
    public static const everyone:int = 3;
}
}