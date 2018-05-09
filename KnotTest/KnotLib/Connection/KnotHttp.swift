//
//  KnotHttp.swift
//  KnotTest
//
//  Created by Rafael Lucena on 2/1/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation
import Alamofire

class KnotHttp {
    
    // MARK: Connection variables
    private let cloudURL = "http://knot-test.cesar.org.br"
    private let port = 3000
    
    // MARK: User credential variables
    private let uuid = "f2c7d7e5-2b14-4172-91d8-256b6ca80000"
    private let token = "3eff25ac9dea999e40de8ed1ba2d42320f52c961"
}

extension KnotHttp {
    
    private func handleError <T> (responseResult result: Result<Any>, paramToBeRead param: String, providerCallback: @escaping ((T?, Error?) -> ()), successCallback: @escaping (([[String : Any]]) -> ())) {
        switch result {
        case .success(let value):
            if let data = value as? [String : Any] {
                if let validatedValue = data[param] as? [[String : Any]] {
                    successCallback(validatedValue)
                } else if let message = data["message"] as? String {
                    providerCallback(nil, KnotSocketError.custom(message: message))
                } else if let message = data["error"] as? String {
                    providerCallback(nil, KnotSocketError.custom(message: message))
                }
            } else {
                providerCallback(nil, KnotSocketError.notDefined)
            }

        case .failure(let error):
            providerCallback(nil, error)
        }
    }
    
    private func generic(opetation callback: ((SessionManager, HTTPHeaders) -> ())?) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 15
        manager.session.configuration.timeoutIntervalForResource = 15
        
        callback?(manager, headers)
    }
    
    func myDevices(callback: @escaping (([BaseDevice]?, Error?) -> ())) {
        generic { (manager, headers) in
            manager.request("\(self.cloudURL):\(self.port)/mydevices", headers: headers)
                .responseJSON { (response) in
                    self.handleError(responseResult: response.result, paramToBeRead: "devices", providerCallback: callback, successCallback: { (data) in
                        let devices = BaseDevice.modelsFromDictionaryArray(array: data as NSArray)
                        callback(devices, nil)
                    })
            }
        }
    }
    
    func data(deviceUUID: String, callback: @escaping (([BaseDeviceData]?, Error?) -> ())) {
        generic { (manager, headers) in
            manager.request("\(self.cloudURL):\(self.port)/data/\(deviceUUID)", headers: headers)
                .responseJSON { (response) in
                    self.handleError(responseResult: response.result, paramToBeRead: "data", providerCallback: callback, successCallback: { (data) in
                        let dataResults = BaseDeviceData.modelsFromDictionaryArray(array: data as NSArray)
                        callback(dataResults, nil)
                    })
            }
        }
    }
}
