//
//  API.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

//Alamofire Help Guide: https://github.com/Alamofire/Alamofire/blob/master/Documentation/Usage.md#response-validation


import UIKit
import Alamofire

//API
//MARK: BASE URL  //SMP: CONFIG
let strBaseUrl = "http://beta.voiceofsap.org/wp-json/custom-api/v3/"
//let strBaseUrl = "https://api.imgur.com"

//MARK: API METHOD NAME
struct APIConstant {
    static let parseErrorDomain = "ParseError"
    static let parseErrorMessage = "Unable to parse data"
    static let parseErrorCode = Int(UInt8.max)
}

struct APIName {
    static let Login = "api/customer/login"
    static let Country = "country-list"
    static let ForgotPassword = "api/people/"
    static let EditProfile = "dit-profile"
    static let UploadImages = "/3/image"
}

class API: NSObject {
    
    static let sharedInstance = API()
    
    private override init() {
        
    }
    
    //MARK: - API calling with Model Class response
    func apiRequestWithModalClass<T:Decodable>(modelClass:T.Type?, apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        let url = strBaseUrl + apiName
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
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
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("\nResponse:\n \(jsonResponse)\n")
                    print("\n<<<=================================>>>\n")
                    
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
        print("\n<<<=================================>>>\n")
        print("API Call: \(url)\n")
        print("Headers: \(String(describing: headersValues))\n")
        print("Parameters: \(String(describing: paramValues))\n")
        
        Alamofire.request(url, method: requestType, parameters: paramValues, encoding: URLEncoding.httpBody, headers: headersValues).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                print("\nResponse:\n \(String(describing: response.result.value))\n")
                print("\n<<<=================================>>>\n")
                SuccessBlock(response.result.value as AnyObject)
            case .failure(let error):
                print(error)
                FailureBlock(error)
            }
        }
    }
    
    //MARK: - Upload API
    func apiRequestUpload(apiName:String, requestType:HTTPMethod, paramValues: Dictionary<String, Any>?, headersValues:Dictionary<String, String>?, imagesData:[Data], uploadKey:String, SuccessBlock:@escaping (AnyObject) -> Void, FailureBlock:@escaping (Error)-> Void) {
        
        let url = strBaseUrl + apiName
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            // import image to request
            for imageData in imagesData {
                //multipartFormData.append(imageData, withName: "\(uploadKey)[]", fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
                multipartFormData.append(imageData, withName:uploadKey as String, fileName: "\(Date().timeIntervalSince1970).png", mimeType: "image/png")
            }
            for (key, value) in paramValues! {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
            
        }, usingThreshold: 0, to: url, method: requestType, headers: headersValues) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("upload progress \(Progress.fractionCompleted)");
                    
                })
                
                upload.responseJSON { response in
                    print("Uploaded Successfully:\n Response:\n \(response)")
                    SuccessBlock(response as AnyObject)
                }
            case .failure(let error):
                print("Uploaded Failed:\n Error:\n \(error)")
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



