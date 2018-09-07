//
//  ServiceModel.swift
//  MobileTestApp
//
//  Created by Sabika Batool on 9/5/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import Alamofire

class ServiceModel: NSObject {
    
    static let sharedModel = ServiceModel()
    
    func getData(urlString:String,loaderTxt:String? = nil,parameters:Dictionary<String,AnyObject>?, header:HTTPHeaders? = nil, success:@escaping (AnyObject) ->Void, failure:@escaping (NSError) ->Void) {
        
        let loader = SwiftLoader()
        if (loaderTxt != nil) {
            loader.showLoader(title: loaderTxt!)
        }
        
        Alamofire.request(urlString, method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: header)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                return .success
            }
            .responseJSON { response in
                debugPrint(response)
                if (loaderTxt != nil) {
                    loader.hideLoader()}
                success(response.result.value as AnyObject)
        }
    }
}
