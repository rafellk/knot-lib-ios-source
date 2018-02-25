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
    private let uuid = "42a8f325-18e4-44ab-8b58-b90883350000"
    private let token = "b3350a94311f770d739b08388cbf61c14d0127c1"
    
    // MARK: Thing UUID variable
    private let deviceUUID = "95f58649-edc9-4f9b-a9ec-30cd08de0001"
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
    
    func myDevices(callback: @escaping (([BaseDevice]?, Error?) -> ())) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"

        Alamofire.request("\(cloudURL):\(port)/mydevices", headers: headers)
//            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                self.handleError(responseResult: response.result, paramToBeRead: "devices", providerCallback: callback, successCallback: { (data) in
                    let devices = BaseDevice.modelsFromDictionaryArray(array: data as NSArray)
                    callback(devices, nil)
                })
            }
    }
    
    func data(uuid: String, callback: @escaping (([BaseDeviceData]?, Error?) -> ())) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = self.uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"

        Alamofire.request("\(cloudURL):\(port)/data/\(uuid)", headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                self.handleError(responseResult: response.result, paramToBeRead: "data", providerCallback: callback, successCallback: { (data) in
                    let dataResults = BaseDeviceData.modelsFromDictionaryArray(array: data as NSArray)
                    callback(dataResults, nil)
                })
            }
    }
    
    func readData(callback: @escaping (([[String : Any]]?, Error?) -> ())) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"
        
        Alamofire.request("\(cloudURL):\(port)/data/\(deviceUUID)", headers: headers)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let value = value as? [String : Any], let data = value["data"] as? [[String : Any]] {
                        callback(data, nil)
                    }
                case .failure(let error):
                    callback(nil, error)
                }
        }
    }
}
