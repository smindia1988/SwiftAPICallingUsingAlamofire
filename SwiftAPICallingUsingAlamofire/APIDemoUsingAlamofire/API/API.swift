//
//  API.swift
//  SwiftyJson4.0
//
//  Created by Hitesh.surani on 11/10/17.
//  Copyright © 2017 Brainvire. All rights reserved.
//

import UIKit
import Alamofire

//API

//MARK: BASE URL
let strBaseUrl = "http://beta.voiceofsap.org/wp-json/custom-api/v3/"

//MARK: API METHOD NAME
let strCountryAPI = "country-list"
let strForgotPassword = "api/people/"
let strloginAPI = "userlogin"
let strEditProfile = "edit-profile"

enum apiType:Int {
    case CountryAPI = 0
    case forgotPasswordAPI = 1
    case loginAPI = 2
    case EditProfile = 3
}

enum HttpMethod : String {
    case  GET
    case  POST
    case  DELETE
    case  PUT
}

class API: NSObject {
    
    var aryUrlString:[String] = [strCountryAPI,strForgotPassword,strloginAPI,strEditProfile]
    
    static let sharedInstance = API()
    
    private override init() {

    }
    
    func apiRequestWithModalClass<T:Decodable>(type:T.Type?,apiTypeValue:apiType,params: Dictionary<String, Any>?, method: HttpMethod,SuccessBlock: @escaping (AnyObject) -> Void,FailureBlock: @escaping (Error?)-> Void) {
        
        let url = strBaseUrl + aryUrlString[apiTypeValue.rawValue]
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).validate().response { (response) in
            
            guard let data = response.data else { return }
            
            do {
                let objModalClass = try JSONDecoder().decode(type!,from: data)
                
                SuccessBlock(objModalClass as AnyObject)
                
            } catch{
                FailureBlock(response.error)
            }
        }
    }
}



