//
//  ApiReqClass.swift
//  ParityCubeAssignment
//
//  Created by apple on 11/01/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit


struct UrlsAndConstants {
    
 static let timeInterval:Double = 30
    
  static let  premiumDealUrl = "http://www.desidime.com/api/v1/premium_deals/list/"
}

class ApiReqClass: NSObject {

    static let sharedApiReq : ApiReqClass = ApiReqClass()
    func fetchTopPopularDealsReq(inpParam: Any? ,completionHandlerForResp:@escaping (_ isError:Bool , _ result:Any , _ responseHttp:HTTPURLResponse) -> Void){
        
      
          let request = self.makePostRequest(url: UrlsAndConstants.premiumDealUrl, inpParam: nil)
        
        (URLSession(configuration: URLSessionConfiguration.default)).dataTask(with: request, completionHandler: {(respData, responseHttp, error) in
            
            if error == nil{
                let isError = false
                guard let result = try? JSONSerialization.jsonObject(with: respData!, options: []) else{
                    print("empty")
                    
                    return
                }
                completionHandlerForResp(isError,result,responseHttp as! HTTPURLResponse)
            }else{
                var errorMsg : String!
                let isError = true
                
                if let httpResp = responseHttp as? HTTPURLResponse{
                    print(" status code\(httpResp.statusCode)")
                    
                    if httpResp.statusCode == 401 {
                        errorMsg = "UnAuthorized"
                    }else{
                        errorMsg = "Network Error"
                    }
                    completionHandlerForResp(isError,errorMsg,responseHttp as! HTTPURLResponse)
                }
            }
            
        }).resume()
    }
    
    
    func makePostRequest(url:String , inpParam : Any?) -> URLRequest {
        
        let strUrl = URL(string: url)
        var request = URLRequest(url: strUrl!, cachePolicy: .reloadIgnoringCacheData, timeoutInterval: UrlsAndConstants.timeInterval)
        request.httpMethod = "POST"
        
        if inpParam != nil {
            request.httpBody =  try? JSONSerialization.data(withJSONObject: inpParam!, options: [])
        }
        
        request.setValue("application/javascript", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request;
    }
}



