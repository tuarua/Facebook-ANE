package com.tuarua.facebook {
public final class Permission {
    /** Provides access to a subset of items that are part of a person's public profile.*/
    public static const publicProfile:String = "public_profile";
    /** Provides access the list of friends that also use your app.*/
    public static const userFriends:String = "user_friends";
    /** Provides access to the person's primary email address.*/
    public static const email:String = "email";
    /** Provides access to a person's personal description (the 'About Me' section on their Profile)*/
    public static const userAboutMe:String = "user_about_me";
    /** Provides access to all common books actions published by any app the person has used.
     * This includes books they've read, want to read, rated or quoted.
     */
    public static const userActionsBooks:String = "user_actions.books";
    /** Provides access to all common Open Graph fitness actions published by any app the person has used.
     * This includes runs, walks and bikes actions.
     */
    public static const userActionsFitness:String = "user_action.fitness";
    /** Provides access to all common Open Graph music actions published by any app the person has used.
     * This includes songs they've listened to, and playlists they've created.
     */
    public static const userActionsMusic:String = "user_actions.music";
    /** Provides access to all common Open Graph news actions published by any app the person
     * has used which publishes these actions.
     * This includes news articles they've read or news articles they've published.
     */
    public static const userActionsNews:String = "user_actions.news";
    /** Provides access to all common Open Graph video actions published by any app the person
     * has used which publishes these actions.
     */
    public static const userActionsVideo:String = "user_actions.video";
    /** Access the date and month of a person's birthday. This may or may not include the person's year of birth,
     * dependent upon their privacy settings and the access token being used to query this field.
     */
    public static const userBirthday:String = "user_birthday";
    /** Provides access to a person's education history through the education field on the User object. */
    public static const userEducationHistory:String = "user_education_history";
    /** Provides read-only access to the Events a person is hosting or has RSVP'd to. */
    public static const userEvents:String = "user_events";
    /** Provides access to read a person's game activity (scores, achievements) in any game the person has played.*/
    public static const userGamesActivity:String = "user_games_activity";
    /** Provides access to a person's gender.*/
    public static const userGender:String = "user_gender";
    /** Provides access to a person's hometown location through the hometown field on the User object.*/
    public static const userHometown:String = "user_hometown";
    /** Provides access to the list of all Facebook Pages and Open Graph objects that a person has liked.*/
    public static const userLikes:String = "user_likes";
    /** Provides access to a person's current city through the location field on the User object.*/
    public static const userLocation:String = "user_location";
    /** Lets your app read the content of groups a person is an admin of through the Groups edge on the User object.*/
    public static const userManagedGroups:String = "user_managed_groups";
    /** Provides access to the photos a person has uploaded or been tagged in.*/
    public static const userPhotos:String = "user_photos";
    /** Provides access to the posts on a person's Timeline. Includes their own posts, posts they are tagged in,
     * and posts other people make on their Timeline. */
    public static const userPosts:String = "user_posts";
    /** Provides access to a person's relationship status,
     * significant other and family members as fields on the User object.*/
    public static const userRelationships:String = "user_relationships";
    /** Provides access to a person's relationship interests as the interested_in field on the User object.*/
    public static const userRelationshipDetails:String = "user_relationship_details";
    /** Provides access to a person's religious and political affiliations.*/
    public static const userReligionPolitics:String = "user_religion_politics";
    /** Provides access to the Places a person has been tagged at in photos, videos, statuses and links.*/
    public static const userTaggedPlaces:String = "user_tagged_places";
    /** Provides access to the videos a person has uploaded or been tagged in.*/
    public static const userVideos:String = "user_videos";
    /** Provides access to the person's personal website URL via the website field on the User object.*/
    public static const userWebsite:String = "user_website";
    /** Provides access to a person's work history and list of employers via the work field on the User object.*/
    public static const userWorkHistory:String = "user_work_history";
    /** Provides access to the names of custom lists a person has created to organize their friends. */
    public static const readCustomFriendlists:String = "read_custom_friendlists";
    /** Provides read-only access to the Insights data for Pages, Apps and web domains the person owns.*/
    public static const readInsights:String = "read_insights";
    /** Provides read-only access to the Audience Network Insights data for Apps the person owns.*/
    public static const readAudienceNetworkInsights:String = "read_audience_network_insights";
    /** Provides the ability to read from the Page Inboxes of the Pages managed by a person.*/
    public static const readPageMailboxes:String = "read_page_mailboxes";
    /** Provides the access to show the list of the Pages that you manage.*/
    public static const pagesShowList:String = "pages_show_list";
    /** Provides the access to manage call to actions of the Pages that you manage.*/
    public static const pagesManageCta:String = "pages_manage_cta";
    /** Lets your app manage Instant Articles on behalf of Facebook Pages administered by people using your app.*/
    public static const pagesManageInstantArticles:String = "pages_manage_instant_articles";
    /// Provides the access to Ads Insights API to pull ads report information for ad accounts you have access to.
    public static const adsRead:String = "ads_read";
}
}