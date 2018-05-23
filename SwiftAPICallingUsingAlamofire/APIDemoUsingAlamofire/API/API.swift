//
//  API.swift
//  SwiftyJson4.0
//
//  Created by Hitesh.surani on 11/10/17.
//  Copyright © 2017 Brainvire. All rights reserved.

//Alamofire Help Guide: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation


import UIKit
import Alamofire

//API

//MARK: BASE URL
let strBaseUrl = "http://beta.voiceofsap.org/wp-json/custom-api/v3/"

//MARK: API METHOD NAME
struct APIConstant {
    static let parseErrorDomain = "ParseError"
    static let parseErrorMessage = "Unable to parse data"
    static let parseErrorCode = Int(UInt8.max)
}

struct APIName {
    static let Country = "country-list"
    static let ForgotPassword = "api/people/"
    static let Login = "userlogin"
    static let EditProfile = "dit-profile"
}

class API: NSObject {
    
    static let sharedInstance = API()
    
    private override init() {

    }
    
    //MARK: - API calling with Model Class response
    func apiRequestWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        let url = strBaseUrl + apiName
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: URLEncoding.httpBody, headers: headersValues).validate().response { (response) in
            
            if((response.error) != nil){
                FailureBlock(response.error!)
            }
            else{
                guard let data = response.data else {
                    FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    return
                }
                
                do {
                    let objModalClass = try JSONDecoder().decode(modelClass!,from: data)
                    print(objModalClass)
                    SuccessBlock(objModalClass as AnyObject)
                } catch{ //If model class parsing fail
                    if(response.error == nil){
                        FailureBlock(self.handleParseError(Data())) //Show Custom Parsing Error
                    }
                    else{
                        print(error.localizedDescription)
                        FailureBlock(response.error!)
                    }
                }
            }
        }
    }
    
    //MARK: - API calling with JSON data response
    func apiRequestWithJsonResponse(apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        let url = strBaseUrl + apiName
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: URLEncoding.httpBody, headers: headersValues).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                //print("Validation Successful")
                SuccessBlock(response.result.value as AnyObject)
            case .failure(let error):
                print(error)
                FailureBlock(error)
            }
        }
    }
    
    //MARK: - Supporting Methods
    fileprivate func handleParseError(_ data: Data) -> Error{
        let error = NSError(domain:APIConstant.parseErrorDomain, code:APIConstant.parseErrorCode, userInfo:[ NSLocalizedDescriptionKey: APIConstant.parseErrorMessage])
        print(error.localizedDescription)
        do { //To print response if parsing fail
            let response  = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            print(response)
        }catch{}
        
        return error
    }
}



