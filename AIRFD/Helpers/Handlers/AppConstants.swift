//
//  AppConstants.swift
//  IRAirport
//
//  Created by Akbarzade on 6/4/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit



/*
enum ChartPointerOriginY : Int{
case REF = 190
case STAR = 240
case APP = 290
case TAXI = 340
case SID = 390
case MINE = 440
}
*/

/**
Frame and construction style.

- REF: For REFERENCE Charts
- STAR: For ARRIVALS Charts
- APP: For APPROACH Charts
- TAXI: For TAXI Charts
- SID: For DEPARTURES Charts
*/







/*
struct Constants{
	
	struct Constants {
		
		// all constants related to service connection
		struct ServiceConstants {
			static let oAuthUserName = "testclient"
			static let oAuthPassword = "123456"
			static let BaseUrlString = "http://fym-api.dbgstage.com"
			static let masterdataUrlString = "/masterdata/all"
			static let logInUrl = "/oauth"
			static let logInFacebookUrl = "/fb-auth"
			static let verifyUserUrl = "/user/verify"
			static let kForgotPasswordUrl = "/user/forgotpassword"
			static let signUpUserUrl = "/user"
			static let fetchProgressUrl = "/progress"
			static let ExerciseLogUrl = "/exerciselog"
			static let ExerciseUrl = "/exercise"
			static let ExerciseCategoryUrl = "/exercise-type"
			static let postWeightAndFatUrl = "/weightlog"
			static let keyPathMeta = "meta"
			static let keyPathAccessToken = "accessToken"
			static let keyPathUserDiet = "diet"
			static let keyPathUserDietOption = "diet_macros"
			static let keyPathUserDetail = "user"
			static let keyPathMasterData = "masterdata"
			static let keyPathErrorMessage = "error_messages"
			static let keyPathFood = "food"
			static let keyPathActivityLevel = "activityLevel"
			static let keyPathNutritionPlan = "nutritionalPlan"
			static let keyPathVerifyUser = "user"
			static let keyPathGoal = "goal"
			static let keyPathGoalOption = "goal_options"
			static let keyPathResults = "results"
			static let keyPathProgressType = "type"
			static let keyPathReport = "report"
			static let keyPathDailyRequirement = "required_per_day"
			static let keyPathMasterBusiness = "businessCategory"
			static let keyPathMasterCreateMeal = "mealCategory"
			
			// Messages
			
			// url's
			static let kUrlGetMessages = "/user/:user_id/message"
			static let kUrlPostMessage = "/user/:user_id/message/:friend_id"
			static let kUrlThreadMessages = "/user/:user_id/message/:friend_id"
			
			// keywords
			static let keyPathMessages = "messages"
			static let keyPathMessage = "message"
			
			// friends
			static let getFriendsUrl = "/user/:user_id/friends"
			static let keyPathGetFriends = "friends"
			
			// friend request
			static let sendFriendRequestUrl = "/user/friend-request/:friend_id"
			static let keyPathSendFriendRequest = "friendRequest"
			
			// friend delete
			static let UnFriendUrl = "/user/:userId/friends/:friendId"
			
			//Update-settings
			//  static let userSettingsUrl1 = "/user/:user_id/user-settings"
			static let keyPathUpdateSettings = "update_settings"
			
			// Update-Info
			static let userUpdateInfoUrl = "/user/:user_id/user-profile"
			static let keyPathUpdateInfo = "update"
			
			// Profile-Pic
			static let ChangeProfilePicUrl = "/user/:user_id/profile-photo"
			static let keyPathChangeProfilePic = "change_profile_photo"
			
			// changePassword
			static let changePasswordUrl = "/user/:user_id/changepassword"
			static let keyPathChangePassword = "change_password"
			
			// settings
			static let userSettingsUrl = "/user/:user_id/user-settings"
			static let keyPathUserSettings = "settings"
			
			// food list
			static let kFoodListUrl = "/meal"
			static let kFoodDetailUrl = "/meal/:barcode"
			
			// food log
			static let kFoodLogUrl = "/foodlog"
			static let keyPathFoodLogResult = "result"
			static let keyPathAchivedMacro = "macros"
			static let kMacroLogUrl = "/macro"
			static let kUrlFood = "/foodlog/:foodlog_id"
			static let keyPathNutrition = "nutrition_facts"
			
			// Invite friends
			static let inviteFriendsUrl = "/user/:userId/invitefriends"
			
			// send friend Requst
			//Send a friend request to a user.
			static let sendFriendsRequestUrl1 = "/user/friend-request"
			
			//exercise
			static let keyPathExerciseLog = "exercise"
			static let keyPathExerciseTypeResult = "result"
			static let keyPathExerciseDetail = "exercise_det"
			static let keyPathDetail = "details"
			static let kUrlExercise = "/exerciselog/:exerciselog_id"
			
			// directory
			static let keyPathBusiness = "business"
			static let keyPathBusinessCategory = "category"
			static let keyPathBusinessImages = "images"
			static let keyPathBusinessHours = "working_hours"
			static let kUrlGetBusiness = "/business-directory"
			static let kUrlPostBusiness = "/check-in"
			
			// news feed
			static let kNewsFeedUrl = "/user/:user_id/feed"
			static let keyPathNewsFeeds = "feeds"
			static let keyPathNewsFeed = "feed"
			static let kHashTagUrl = "/feed/hashtag/:hashtag"
			
			// news feed comments
			static let kNewsFeedCommentsUrl = "/user/:userId/feed/:feedId/comments"
			static let keyPathNewsFeedComment = "feed_comment"
			static let keyPathNewsFeedComments = "comments"
			
			// news feeds :Get feeds of a particular user.
			static let kNewsFeedParticularUserUrl = "/user/:user_id/user-profile/feeds"
			
			// meal type
			static let kMealTypeListUrl = "/meal-type"
			static let keyPathMealType = "meal_type"
			
			// user-Profile
			static let followingfollowerUrl = "/user/:userId/follow"
			static let keyPathFollowingFollower = "follow_list"
			static let kUrlGetUserDetailResponse = "/user/:userid/user-profile"
			
			
			// motivate url -like ,inspire,comment
			static let motivateUrl = "/user/:user_id/feed/:feed_id/motivate"
			
			// manage goals
			static let kManageGoalsUpdateUrl = "/user/:user_id"
			
			// follow
			static let kFollowUrl = "/user/:user_id/follow/:friend_id"
			
			// create meal
			static let keyPathMealFoodList = "food"
			static let kUrlPostCreateMeal = "/meal"
			// Ads
			static let keyPathAds = "ads"
			static let adsUrl = "/ad"
			
			// facebookConnectUrl
			static let facebookConnectUrl = "/fb-connect"
			
		}
		
		struct StoryboardNames {
			static let registration = "RegistrationStoryboard"
			static let main = "Main"
			static let mamageGoals = "ManageGoalsStoryboard"
		}
		
		struct Tables {
			static let progressReportTable = "ProgressReport"
			static let progressTable = "Progress"
			static let dailyRequirement = "DailyRequirement"
			static let ProgressFirstLog = "ProgressFirstLog"
			static let ProgressLastLog = "ProgressLastLog"
			static let MacroPerReportingPeriod = "MacroPerReportingPeriod"
		}
		
		// notifications
		
		// refresh message get api in message list
		static let messageListRefresh = "MessageListRefresh"
		static let updateUserProfile = "UpdateProfile"
	}
}
*/