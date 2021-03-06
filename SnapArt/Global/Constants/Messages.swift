//
//  Messages.swift
//  SnapArt
//
//  Created by HD on 10/14/15.
//  Copyright (c) 2015 Duc Ngo Hoai. All rights reserved.
//

import Foundation

struct MESSAGES{
    static let SA_ALERT_TIL = "SnapArt"
    
    struct NOTIFY {
        static let LOGIN_SUCCESS = "LoginSuccess"
        static let REMOVE_LAUNCH_SCREEN = "LaunchScreen"
        static let RESET_COST = "ResetCost"
        static let CHECKOUT_LOGIN = "CheckoutLogin"
        static let COMEBACKHOME = "ComeBackHomeVC"
        static let GO_LOGIN = "GoToLogin"
        static let CHECK_ORDER = "CheckNumberOfOrder"
    }
    
    struct COMMON{
        static let NOT_INTERNET = "Unable to connect to the internet please try again later."
        static let API_EXCEPTION = "Error. Please try again."
        static let EMAIL_EMPTY = "Email can't be blank."
        static let EMAIL_INVALID = "Email is invalid."
        static let FRAME_SIZE_INVALID = "Please choose frame size."

        static let LOADING = "Loading..."
        static let ORDER_EXISTED = "A previously saved order was found, do you want to continue with it?"
        static let CAN_NOT_GET_LOCATION = "Can't check your location, please check again."
    }
    
     struct REGISTER{
        static let PASS_INVALID = "Password is too short (minimum is 6 characters)."
        static let NEW_PASS_INVALID = "New Password is too short (minimum is 6 characters)."
        static let OLD_PASS_EMPTY = "Old Password can't be blank."
        static let RE_PASS_EMPTY = "Re - Enter Password can't be blank."
        static let PASS_EMPTY = "Password can’t be blank."
        static let VERIFICATION_EMPTY = "Code can’t be blank."
        static let COMPARE_PASSWORD = "Re - Enter Password and Password don’t match."
        static let NEW_PASSWORD_EMPTY = "New Password can't be blank."
        static let COMPARE_FORGOT_PASSWORD = "Confirm New Password and Password don’t match"
    }
    
    struct SHOPPING {
        static let SHOPPING_QUESTION = "For an extra $0.99, your art is wrapped in high - quality gift wrap before being securely packaged for delivery."
        static let SHOPPING_CART_IS_EMPTY = "Your cart is empty."
        static let MAX_FRAME_LIST = "Maximum 3 records are allowed."
    }
    
    struct MAKE_ART{
        static let IMAGE_ERROR = "The photo you uploaded is too big, please select other."
    }
}