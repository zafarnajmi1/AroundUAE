//
//  Params.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 23/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import UIKit

//MARK: - Custom Param's

typealias StoreProductUpdated = (
    storeID:String,
    topRated:String,
    categories:[String]?
)

typealias LoginParams = (
    useremail:String,
    userpassword:String
)

typealias RegisterUserParams = (
    userfullname:String,
    useremail: String,
    userphoneno: String,
    userpassword: String,
    userconfirmpassword: String,
    useraddress: String,
    usernic: Data,
    usergender: String,
    TnCsAccpeted: String
)

typealias EmailverificationParams = (
    email: String,
    verificationCode: String
)

typealias resetPasswordParams = (
    email: String,
    verificationCode: String,
    password: String,
    passwordConfirmation: String
)

typealias changePasswordParams = (
    oldPassword: String,
    password: String,
    passwordConfirmation: String
)

typealias updateProfileParams = (
    fullName:String,
    email:String,
    phone:String,
    address:String,
    gender:String,
    nic:UIImage
)
//typealias updateTradeLicence = (
//    tradeLicense:String,
//    email:String,
//    phone:String,
//    address:String,
//    gender:String,
//    nic:UIImage
//)

typealias AboutPageParams = (
    description_en:String,
    description_ar:String,
    image:UIImage,
    id:String
)

typealias ContactUSParams = (
    name:String,
    email:String,
    subject:String,
    message:String
)

typealias DeleteProductImageParams = (
    productid:String,
    imageId:String
)
typealias CityEventsParams = (
    cityid:String,
    page:String,
    keyword:String
)

typealias AddEventParams = (
    cityID:String,
    title:String,
    description:String,
    eventDate:String,
    startTime : String,
    endTime : String,
    isActive : String,
    eventImage:Data,
    
    fullName : String,
    email : String,
    phoneNumber : String,
    eventEndDate:String
    
)
typealias CitiesPlacesParams = (
    cityid:String,
    page:String,
    longitude:String,
    latitude:String
)

typealias SubmitPlaceReviewParams = (
    place:String,
    rating:String,
    comment:String
)

typealias PlaceReviewsListingParams = (
    page:String,
    place:String
)

typealias ProductReviewParams = (
    productid:String,
    rating:String,
    comment:String
)

typealias StoreReviewParams = (
    store:String,
    rating:String,
    comment:String
)

typealias AddCartproductsParams = (
    productid:String,
    quantity:String,
    features:[String],
    characteristics:[String]
)

typealias DeleteProductCartParams = (
    product:String,
    combination:String
)

typealias CartQuantityUpdateParams = (
    quantity:String,
    product:String,
    combination:String
)

typealias SocialParams = (
    id:String,
    accessToken:String,
    email:String,
    authMethod:String,
    fullName:String
)

typealias SearchParams = (
    locale:String,
    skip:String,
    minPrice:String?,
    maxPrice:String?,
    location:[String],
    key:String,
    manufacturers:[String],
    groups:[String],
    divisions:[String],
    sections:[String],
    characterisrics:[String],
    isNear: String
    
)


typealias SearchFilterParams = (
    groupid:String,
    divisionid:String
)

typealias FeaturesAndCharacteristicsParams = (
    divisions: [String],
    sections: [String]
)

typealias BillingShippingAddressParams = (
    fullname:String,
    email:String,
    phone:String,
    addressone:String,
    addresstwo:String,
    addressthree:String,
    addresstype:String
)

typealias StoreUploadSelfieParams = (
    storeid:String,
    caption:String,
    selfieData:Data,
    thumbnail:Data,
    mintype:String
)

typealias PlaceUploadSelfieParams = (
    placeId:String,
    caption:String,
    selfieData:Data,
    thumbnail:Data,
    mintype:String
)


typealias UploadGalleryParams = (
    storeid:String,
    file:Data,
    thumbnail:Data
)
