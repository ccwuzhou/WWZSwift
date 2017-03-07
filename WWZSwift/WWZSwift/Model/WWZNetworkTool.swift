//
//  WWZNetworkTool.swift
//  webo_swift
//
//  Created by wwz on 17/2/27.
//  Copyright © 2017年 tijio. All rights reserved.
//

import UIKit
import AFNetworking

enum WWZRequestType: String {
    case GET = "GET"
    case POST = "POST"
}

class WWZNetworkTool: AFHTTPSessionManager {

    static let shareInstance : WWZNetworkTool = {
    
        let tools = WWZNetworkTool()
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        
        return tools
    }()
    
    // MARK: -请求方法
    public func request(_ methodType: WWZRequestType, urlString: String, parameters: [String: Any]?, success: ((_ result: Any?)->())?, failure: ((_ error: Error?)->())?) {
        
        let successCallBack = { (task: URLSessionDataTask, result: Any?) -> Void in

            success?(result)
        }
        let failureCallBack = { (task: URLSessionDataTask?, error: Error)  -> Void in
            
            failure?(error)
        }
        
        if methodType == .GET {
        
            self.get(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
            
        }else{
        
            self.post(urlString, parameters: parameters, progress: nil, success: successCallBack, failure: failureCallBack)
        }
    }
}
