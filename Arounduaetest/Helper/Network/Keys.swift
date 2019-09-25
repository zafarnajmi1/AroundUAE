//
//  Keys.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 23/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Foundation

//MARK: - Auth Key's
enum LoginKey: String{
    case USER_EMAIL       = "email"
    case USER_PASSWORD    = "password"
}

enum ForgotpasswordKey: String{
    case USER_EMAIL  = "email"
}

enum RegisterUserKey: String{
    case USER_FULLNAME = "fullName"
    case USER_EMAIL = "email"
    case USER_PHONE = "phone"
    case USER_PASSWORD = "password"
    case USER_CONFIRMATION = "passwordConfirmation"
    case USER_ADDRESS = "address"
    case USER_NIC = "nic"
    case USER_GENDER = "gender"
    case TnCsACCEPTED = "isTermsConditionsAccepted"
}

enum EmailverificationKey: String{
    case EMAIL = "email"
    case VERIFICATION_CODE = "verificationCode"
}

enum resendverificationKey: String{
    case EMAIL = "email"
}

enum resetpasswordKey: String{
    case EMAIL = "email"
    case VERIFICATION_CODE = "verificationCode"
    case PASSWORD = "password"
    case PASSWORD_CONFIRMATION = "passwordConfirmation"
}

//MARK: - Store Key's
enum pageKey: String{
    case PAGE = "page"
}

enum storeDetilKey: String{
    case STORE_ID = "storeId"
}

//MARK: - Profile Key's
enum changePasswordKey:String{
    case OLD_PASSWORD = "oldPassword"
    case PASSWORD = "password"
    case CONFIRMATION_PASSWORD = "passwordConfirmation"
}

enum updateProfileKey:String{
    case FULLNAME = "fullName"
    case EMAIL = "email"
    case PHONE = "phone"
    case ADDRESS = "address"
    case GENDER = "gender"
    case NIC = "nic"
}

enum AboutPageKey:String{
    case DESCRIPTION_EN = "description[en]"
    case DESCRIPTION_AR = "description[ar]"
    case IMAGE = "image"
    case ID = "id"
}

enum ProductDetailKey:String{
    case PRODUCT_ID = "productId"
}

enum StoreProductKey:String{
    case STORE_ID = "storeId"
    case PAGENO = "page"
}
enum StorProductupdatedKey : String{
//    'category', 'subcategory', 'topRated': false, 'storeId'
    case storeId = "storeId"
    case topRated = "topRated"
    case categories = "categories"
}
enum StoreProductsID:String{
    case storeId = "storeid"
    case PageNo = "page"
}

enum EditProductKey:String{
    case PRODUCT_ID = "id"
}

enum DeleteProductImageKey:String{
    case PRODUCT_ID = "id"
    case IMAGE_ID = "imageId"
}

enum ContactUsKey:String{
    case NAME = "name"
    case EMAIL = "email"
    case SUBJECT = "subject"
    case MESSAGE = "message"
}
enum CityEventsKey:String{
    case CITY_ID = "cityId"
    case PAGE = "page"
    case KEYWORD = "keyword"
}
enum AddEventKey:String{

    case TITLE = "title"
    case CITY_ID = "city"
    case DESCRIPTION = "description"
    case EVENT_DATE =  "eventStartDate"
    case EVENT_END_DATE = "eventEndDate" //"eventDate"
    case START_TIME = "startTime"
    case END_TIME = "endTime"
    case ISACTIVE = "isActive"
    case FuLLNAME = "fullName"
    case EMAIL = "email"
    case PHONE = "phone"
    
}
enum EventDetailKey:String{
    case EVENTID = "_id"
}
enum CitiesPlacesKey:String{
    case CITY_ID = "cityId"
    case PAGE = "page"
    case LONGITUDE = "longitude"
    case LATITUDE = "latitude"
}

enum SubmitPlaceReviewKey:String{
    case PLACE = "place"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum PlaceReviewsListingkey:String{
    case PAGE = "page"
    case PLACE = "place"
}

enum PlaceKey:String{
    case PLACE_ID = "placeId"
}

enum GroupKey:String{
    case GROUP_ID = "groupId"
}

enum ProductKey:String{
    case PRODUCT_ID = "productId"
}

enum ProductReviewKey:String{
    case PRODUCT_ID = "product"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum StoreReviewKey:String{
    case STORE = "store"
    case RATING = "rating"
    case COMMENT = "comment"
}

enum AddToCartKey:String{
    case product = "product"
    case quantity = "quantity"
    case featureszero = "features[0]"
    case characteristicsone = "characteristics[0]"
}

enum DeleteProductCartKey:String{
    case product = "product"
    case combination = "combination"
}

enum CartQuantityUpdateKey:String{
    case quantity = "quantity"
    case product = "product"
    case combination = "combination"
}

enum PaymentKey:String{
    case payerId = "paymentId"
    case paymentMethod = "paymentMethod"
    case token = "token"
}

enum SocialKey:String{
    case id = "id"
    case accessToken = "accessToken"
    case email = "email"
    case authMethod = "authMethod"
    case fullName = "fullName"
}

enum SearchKey:String{
    case locale = "locale"
    case minPrice = "minPrice"
    case maxPrice = "maxPrice"
    case location = "location"
    case key = "keyword"
    case Skip = "skip"
    case isNear = "isNear"
}

enum UpdateBillingShippingKey:String{
    case fullName = "fullName"
    case email = "email"
    case phone = "phone"
    case address1 = "address1"
    case address2 = "address2"
    case address3 = "address3"
    case addressType = "addressType"
}

enum StoreUploadSelfieKey:String{
    case storeid = "storeId"
    case caption = "caption"
    case file = "file"
    case thumbnail = "thumbnail"
}

enum PlaceUploadSelfieKey:String{
    case placeid = "placeId"
    case caption = "caption"
    case file = "file"
    case thumbnail = "thumbnail"
}

enum UploadGalleryKey:String{
    case storeId = "storeId"
    case file = "file"
    case thumbnail = "thumbnail"
}
