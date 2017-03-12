//
//  FLYObjectManager.swift
//  flyTest
//
//  Created by vivek verma on 09/03/17.
//  Copyright © 2017 vivek. All rights reserved.
//

import UIKit
import Alamofire

class FLYObjectManager: NSObject {
    
    typealias SUCCESS_BLOCK = (_ responseObject : AnyObject?) ->Void
    typealias FAILURE_BLOCK = (_ error : NSError?) ->Void
    
    //MARK: Shared Instance
    static let sharedInstance : FLYObjectManager = {
        let instance = FLYObjectManager()
        return instance
    }()
    
    open func getObjectWithUrlPath(urlPath : String, params : String, success : @escaping SUCCESS_BLOCK, failure : @escaping FAILURE_BLOCK ) {
        let encodedParams : String = params.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        let urlParamEncodedString : String = "\(urlPath)\(encodedParams)"
        let URL = NSURL(string: urlParamEncodedString)
        var mutableUrlRequest = URLRequest(url: URL! as URL)
        mutableUrlRequest.httpMethod = "GET"
        
        mutableUrlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        mutableUrlRequest.setValue("Bearer \(Globals.ACCESS_TOKEN)", forHTTPHeaderField: "Authorization")
        
        Alamofire.request(mutableUrlRequest).responseJSON { response in
            switch response.result {
            case .success:
                success(response.result.value as AnyObject?)
            case .failure(let error):
                failure(error as NSError?)
            }
        }
    }
}
