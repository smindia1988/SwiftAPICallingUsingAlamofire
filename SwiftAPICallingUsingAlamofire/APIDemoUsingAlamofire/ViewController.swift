//
//  ViewController.swift
//  APIDemoUsingAlamofire
//
//  Created by bviadmin on 22/05/18.
//  Copyright © 2018 BV. All rights reserved.
//

import UIKit

struct ModelCountry : Decodable {
    //let id: String?
    let name: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        ///*
        //[1] Sample - Call api with Model Class response
        API.sharedInstance.apiRequestWithModalClass(modelClass: [ModelCountry].self, apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            let countryObj = response as! [ModelCountry]
            print(countryObj[0].name!)
            
        },FailureBlock:{ (error) in
            
            print(error.localizedDescription)
        })
        //*/
        
        
        /*
        //[2] Sample - Call api with JSON data response
        API.sharedInstance.apiRequestWithJsonResponse(apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            let arrayData = response as! Array<[String : AnyObject]>
            print(arrayData[0]["name"]!)
            
        }, FailureBlock:{ (error) in
            print(error.localizedDescription)
        })
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

