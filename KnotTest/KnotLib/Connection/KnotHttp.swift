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
    private let uuid = "b7f8bbed-767f-4e5e-9770-46d8a1510000"
    private let token = "af91eaebc52c4ff332e530c701ff3f704e6c091b"

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
    
    private func generic(opetation callback: ((SessionManager, HTTPHeaders) -> ())?) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 30
        manager.session.configuration.timeoutIntervalForResource = 30
        
        callback?(manager, headers)
    }
    
    func myDevices(callback: @escaping (([BaseDevice]?, Error?) -> ())) {
        generic { [weak self] (manager, headers) in
            if let url = self?.cloudURL, let port = self?.port {
                manager.request("\(url):\(port)/mydevices", headers: headers)
                    .responseJSON { (response) in
                        self?.handleError(responseResult: response.result, paramToBeRead: "devices", providerCallback: callback, successCallback: { (data) in
                            let devices = BaseDevice.modelsFromDictionaryArray(array: data as NSArray)
                            callback(devices, nil)
                        })
                }
            }
        }
    }
    
    func data(deviceUUID: String, callback: @escaping (([BaseDeviceData]?, Error?) -> ())) {
        generic { [weak self] (manager, headers) in
            if let url = self?.cloudURL, let port = self?.port, let uuid = self?.uuid {
                manager.request("\(url):\(port)/data/\(uuid)", headers: headers)
                    .responseJSON { (response) in
                        self?.handleError(responseResult: response.result, paramToBeRead: "data", providerCallback: callback, successCallback: { (data) in
                            let dataResults = BaseDeviceData.modelsFromDictionaryArray(array: data as NSArray)
                            callback(dataResults, nil)
                        })
                }
            }
        }
    }
}
