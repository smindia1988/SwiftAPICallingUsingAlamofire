# SwiftAPICallingUsingAlamofire


**Set your Base URL in API.swift class**
//MARK: BASE URL
`let strBaseUrl = "YOUR BASE URL"`


**Add your API name here in API.swift class**

`struct APIName {`

`static let Country = "country-list"`

`static let ForgotPassword = "api/people/"`

`static let Login = "userlogin"`

`}`


**Create Model struct as per your requirement:**

`struct ModelCountry : Decodable {`

`let id: String?`

`let name: String?`

`}`

**Make API service call with response in Model Class:**

//[1] Sample - Call api with Model Class response

`API.sharedInstance.apiRequestWithModalClass(modelClass: [ModelCountry].self, apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in`


`let countryObj = response as! [ModelCountry]`

`print(countryObj[0].name!)`


`},FailureBlock:{ (error) in`

`print(error.localizedDescription)`

`})`


**Make API service call with response in JSON:**

//[2] Sample - Call api with JSON data response
`API.sharedInstance.apiRequestWithJsonResponse(apiName: APIName.Country, requestType: .get, paramValues: nil, headersValues: nil, SuccessBlock: { (response) in`

`let arrayData = response as! Array<[String : AnyObject]>`

`print(arrayData[0]["name"]!)`

`}, FailureBlock:{ (error) in`

`print(error.localizedDescription)`

`})`

**Make API service call Multiple Upload:**

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
