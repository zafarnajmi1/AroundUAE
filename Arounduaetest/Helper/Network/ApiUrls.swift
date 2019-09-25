//
//  ApiUrls.swift
//  BOOSTane
//
//  Created by Mohsin Raza on 26/02/2018.
//  Copyright © 2018 SDSol Technologies. All rights reserved.
//

import Foundation

//MARK: - Urls
enum APIURL: String{
    //https://www.projects.mytechnology.ae/around-uae
    case mainURL = "https://www.projects.mytechnology.ae/around-uae/api/"
    //"https://hello-stream.com/projects/around-uae/api/"
    //"http://216.200.116.25/around-uae/api/"
    case loginURL                  = "login"
    case forgotpasswordURL         = "forgot/password"
    case registrationURL           = "register"
    case emailverificationURL      = "auth/email-verification"
    case resendverificationURL     = "auth/resend-verification-code"
    case resetPasswordURL          = "reset/password"
    case facebookURL               = "user/social-login?facebook_id="
    case googleURL                 = "user/social-login?google_id="
    
    case getStoreURL               = "stores"
    case storeDetailURL            = "auth/store/detail"
    case getResturantsURL          = "restaurants"
    case storeReviewURL            = "auth/store/review"
    
    case getUserProfileURL         = "auth/user-profile"
    case changePasswordURL         = "auth/change-password"
    case updateProfileURL          = "auth/update-profile"
    case uploadImageURL            = "auth/upload-image"
    case removeImageURL            = "auth/remove-image"
    case aboutPageURL              = "auth/manage/about-page"
    case userStoresURL             = "auth/user/stores"

    case productDetailURL          = "auth/product/detail"
    case storeProductsURL          = "auth/products"
 
    case editProductURL            = "auth/products/edit"

    case deleteProductURL          = "auth/products/delete"
    case deleteProductImageURL     = "auth/products/delete/image"
    case setDefaultProductImageURL = "auth/products/default/image"
    case getStoreSGDS              = "auth/products/get/data"
    case getFeaturesCharacters     = "features-and-characteristics"
    
    case getSiteSettingsURL        = "settings"
    case getSlidersURL             = "sliders"
    case contactUsURL              = "contact-us"
    
    case addToCartURL              = "auth/cart/add-product"
    case deleteCarProductURL       = "auth/cart/product/remove"
    case cartQuantityUpdateURL     = "auth/cart/update"
    case paymentURL                = "auth/payment"
    case getCartProductsURL        = "auth/cart"
    /*********************Asif Habib************************/
    case cityEventsURL             = "city/events"
    case addEvent                  = "auth/events/store"
    case eventDetail               = "city/event/detail"
    case categories                = "auth/categories"
    /*******************************************************/
    case getCitiesURL              = "cities"
    case citiesPlacesURL           = "city/places"
    case cityPlaceDetailURL        = "city/place/detail"
    case submitPlaceReviewURL      = "auth/place/review"
    case placeReviewListingURL     = "place/reviews"
    case makePlaceFavouriteURL     = "auth/place/favourite"
    case favouritePlaceListURL     = "auth/place/favourite/list"
    case getGroupsURL              = "groups"
    case getGroupWithDivisionURL   = "groups/divisions"
    case makeProductFavouriteURL   = "auth/product/favourite"
    case getFavouriteProductsURL   = "auth/favourite/products"
    case productReviewURL          = "auth/product/review"
    case searchProductURL          = "product/search"
    case socialLoginURL            = "social-login"
    case filterURL                 = "search-filters"
    case UpdateBillingShippingURL  = "auth/update/user-addresses"
    
    case showConfirmedShippedCompletedOrdersURL = "auth/orders/show"
    case shipOrderProductURL                    = "auth/ship/product"
    case OrderDetailURL                         = "auth/order/detail"
    case MakeProductCompleteURL                 = "auth/complete/product"
    
    case StoreUploadURL                         = "auth/store/upload/selfie"
    case PlaceUploadURL                         = "auth/place/upload/selfie"
    case GetSelfieURL                           = "auth/stores/edit"
    case SetSelfieactiveURL                     = "auth/store/selfie/active"
    case DeleteGalleryURL                       = "auth/store/delete/gallery"
    case UploadGalleryURL                       = "auth/store/upload/gallery"
    case storProductsUrlUpdated                 = "store/products"
    
    
    
    
    
}
