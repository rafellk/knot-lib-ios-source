//
//  KnotSocketIO.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/27/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation
import SocketIO

// todo: elabora all possible errors
enum KnotSocketError: Error {
    case timeout
    case notFound
    case custom(message: String)
    
    // todo: remove this for the real error name
    case notDefined
    
    // todo: localize this messages
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "The request timed out"
        case .notFound:
            return "Resource not found"
        case .custom(let message):
            return message
        default:
            return ""
        }
    }
}

class KnotSocketIO {
    
    // MARK: Connection variables
    private let cloudURL = "http://knot-test.cesar.org.br"
    private let port = 3000
    
    // MARK: User credential variables
    private let uuid = "42a8f325-18e4-44ab-8b58-b90883350000"
    private let token = "b3350a94311f770d739b08388cbf61c14d0127c1"
    
    // MARK: Thing UUID variable
    private let deviceUUID = "95f58649-edc9-4f9b-a9ec-30cd08de0001"
    
    // MARK: Variables
}

extension KnotSocketIO {
    
    // todo: define error enum
    private func connect(callback: @escaping (SocketIOClient?, KnotSocketError?) -> ()) {
        let manager = SocketManager(socketURL: URL(string: "\(cloudURL):\(port)")!, config: [])
        let socket = manager.defaultSocket
        
        socket.on(KnotSocketClientEvent.ready.rawValue) {data, ack in
            callback(socket, nil)
        }
        
        socket.on(KnotSocketClientEvent.notReady.rawValue) {data, ack in
            // todo: dispatch error here - something like: "unable to connect to server"
            print("socket not ready")
            callback(nil, KnotSocketError.timeout)
        }
        
        socket.on(KnotSocketClientEvent.identify.rawValue) {data, ack in
            var params = [String : AnyObject]()
            
            params["uuid"] = self.uuid as AnyObject
            params["token"] = self.token as AnyObject

            let emitCallback = socket.emitWithAck(KnotSocketClientEvent.identity.rawValue, params)
            
            emitCallback.timingOut(after: 0, callback: { (data) in
                if manager.status != .connected {
                    // todo: dispatch error here - "request timed out and no response was sent" (timeout error)
                    print("\(data)")
                }
            })
        }

        manager.connect()
    }
    
    private func genericOperation<T> (operation: @escaping ((SocketIOClient) -> ()), callback: @escaping (T?, KnotSocketError?) -> ()) {
        connect(callback: { (socket, error) in
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            guard let socket = socket else {
                // todo: dispatch error here: socket can not be nil
                callback(nil, KnotSocketError.timeout)
                return
            }
            
            operation(socket)
        })
    }
}

extension KnotSocketIO {
    
    func getDevices(callback: @escaping (AnyObject?, KnotSocketError?) -> ()) {
        let operation: ((SocketIOClient) -> ()) = { socket in
            
            var params = [String : AnyObject]()
            params["gateways"] = ["*"] as AnyObject
            
            let emitCallback = socket.emitWithAck(KnotSocketClientEvent.devices.rawValue, params)
            
            emitCallback.timingOut(after: 5, callback: { (data) in
                print("data: \(data)")
                
                if data.count > 0 {
                    //                    guard result["Error"] == nil else {
                    //                        // todo: dispatch error
                    //                        // todo: verify if we really need this verification
                    //                        return
                    //                    }
                    //
                    
                    var devices = [[String : Any]]()
                    
                    for result in data {
                        if let result = result as? [String : AnyObject], let error = result["error"] as? [String : AnyObject] {
                            print("An error occurred: \(error)")
                            // todo: dispatch the correct error here
                            if let message = error["message"] as? String {
                                callback(nil, KnotSocketError.custom(message: message))
                            }
                            return
                        }
                        
                        if let result = result as? NSArray {
                            for subResult in result {
                                if let subResult = subResult as? NSDictionary {
                                    var device = [String : Any]()
                                    device["name"] = subResult["name"]
                                    device["type"] = subResult["type"]
                                    device["uuid"] = subResult["uuid"]
                                    device["online"] = subResult["online"]
                                    devices.append(device)
                                }
                            }
                        }
                    }
                    
                    callback(devices as AnyObject, nil)
                } else {
                    // todo: dispatch error here: timeout
                    callback(nil, KnotSocketError.timeout)
                }
            })
        }
        
        genericOperation(operation: operation, callback: callback)
    }
    
    func getData(thingUUID: String, sensorID: Int, callback: @escaping ([[String : Any]]?, KnotSocketError?) -> ()) {
        let operation: ((SocketIOClient) -> ()) = { socket in
            
            var params = [String : Any]()
            params["uuid"] = thingUUID
            
            let sensorID = ["sensor_id" : sensorID]
            let json = try! JSONSerialization.data(withJSONObject: sensorID, options: .prettyPrinted)
            params["get_data"] = [json]
            
            let emitCallback = socket.emitWithAck(KnotSocketClientEvent.update.rawValue, params)
            
            emitCallback.timingOut(after: 0, callback: { (data) in
                print("data: \(data)")
                
                if let data = data as? [[String : Any]] {
                    //                    if let error = first["error"] {
                    //                        callback(nil, KnotSocketError.notFound)
                    //                        return
                    //                    }
                    
                    callback(data, nil)
                } else {
                    // todo: dispatch error here: timeout
                    callback(nil, KnotSocketError.timeout)
                }
            })
        }
        
        genericOperation(operation: operation, callback: callback)
    }
    
    func setData(callback: @escaping (AnyObject?, KnotSocketError?) -> ()) {
        let operation: ((SocketIOClient) -> ()) = { socket in
            
            var params = [String : Any]()
            params["uuid"] = self.deviceUUID
            
            let sensorID: [String : Any] = [
                "sensor_id" : 1,
                "value": true
            ]
            
            let json = try! JSONSerialization.data(withJSONObject: sensorID, options: .prettyPrinted)
            params["set_data"] = [json]
            
            let emitCallback = socket.emitWithAck(KnotSocketClientEvent.update.rawValue, params)
            
            emitCallback.timingOut(after: 0, callback: { (data) in
                print("data: \(data)")
                
                if data.count > 0, let first = data.first as? NSDictionary {
                    if let error = first["error"] {
                        callback(nil, KnotSocketError.notFound)
                        return
                    }
                    
                    callback(data as AnyObject, nil)
                } else {
                    // todo: dispatch error here: timeout
                    callback(nil, KnotSocketError.timeout)
                }
            })
        }
        
        genericOperation(operation: operation, callback: callback)
    }
}
