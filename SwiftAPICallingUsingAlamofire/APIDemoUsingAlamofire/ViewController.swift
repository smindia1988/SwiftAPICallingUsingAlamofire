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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callAPIWithModelClassResponse(_ sender: Any) {
        
        //[1] Sample - Call api with Model Class response
        API.sharedInstance.apiRequestWithModalClass(modelClass: [ModelCountry].self, apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            let countryObj = response as! [ModelCountry]
            print(countryObj[0].name!)
            
        },FailureBlock:{ (error) in
            
            print(error.localizedDescription)
        })
    }
    @IBAction func callAPIWithModelJsonResponse(_ sender: Any) {
        
        //[2] Sample - Call api with JSON data response
        API.sharedInstance.apiRequestWithJsonResponse(apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in
            
            let arrayData = response as! Array<[String : AnyObject]>
            print(arrayData[0]["name"]!)
            
        }, FailureBlock:{ (error) in
            print(error.localizedDescription)
        })
    }
    @IBAction func callAPIUplod(_ sender: Any) {
     
        //[3] Sample - Multiple Upload API
        
        let image1 = UIImage(named: "tempImage1")
        let image2 = UIImage(named: "tempImage2")
        let imagesData = [UIImagePNGRepresentation(image1!), UIImagePNGRepresentation(image2!)]
        
        let headers = ["Authorization":"Client-ID <Your_Client_ID>"]
        let params = ["title":"Test Upload", "description":"Test description"]
        
        API.sharedInstance.apiRequestUpload(apiName: APIName.UploadImages, requestType: .post, paramValues: params, headersValues: headers, imagesData: imagesData as! [Data], uploadKey:"image",SuccessBlock: { (response) in
            
            //Do your next task after uplod success...
            print(response)
            
        },FailureBlock: { (error) in
            print(error.localizedDescription)
        })
    }
}

