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
    
    func myDevices(callback: @escaping (([[String : Any]]?, Error?) -> ())) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"

        Alamofire.request("\(cloudURL):\(port)/mydevices", headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any], let devices = data["devices"] as? [[String : Any]]{
                        callback(devices, nil)
                    } else {
                        callback(nil, KnotSocketError.notDefined)
                    }
                case .failure(let error):
                    callback(nil, error)
                }
            }
    }
    
    func data(uuid: String, callback: @escaping (([[String : Any]]?, Error?) -> ())) {
        var headers = HTTPHeaders()
        
        headers["meshblu_auth_uuid"] = self.uuid
        headers["meshblu_auth_token"] = token
        headers["Content-Type"] = "application/json"

        Alamofire.request("\(cloudURL):\(port)/data/\(uuid)", headers: headers)
            .validate(statusCode: 200..<300)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let data = value as? [String : Any], let devices = data["data"] as? [[String : Any]]{
                        callback(devices, nil)
                    } else {
                        callback(nil, KnotSocketError.notDefined)
                    }
                case .failure(let error):
                    callback(nil, error)
                }
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
