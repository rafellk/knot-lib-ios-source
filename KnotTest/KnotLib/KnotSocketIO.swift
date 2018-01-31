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
    
    // todo: remove this for the real error name
    case notDefined
    
    // todo: localize this messages
    var localizedDescription: String {
        switch self {
        case .timeout:
            return "The request timed out"
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
    private let uuid = "c28c23c6-3de9-4dd5-afee-c2e3bdd00000"
    private let token = "31cf7222a1d8ab13238eead0c3b6d904fe140875"
    
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
    
    private func genericOperation(operation: @escaping ((SocketIOClient) -> ()), callback: @escaping (AnyObject?, KnotSocketError?) -> ()) {
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
    
    func getDevices(callback: @escaping (AnyObject?, KnotSocketError?) -> ()) {
        let operation: ((SocketIOClient) -> ()) = { socket in
            
            var params = [String : AnyObject]()
            params["gateways"] = ["*"] as AnyObject
            
            let emitCallback = socket.emitWithAck(KnotSocketClientEvent.devices.rawValue, params)
            
            emitCallback.timingOut(after: 5, callback: { (data) in
                if data.count > 0, let result = data[0] as? [String : AnyObject] {
//                    guard result["Error"] == nil else {
//                        // todo: dispatch error
//                        return
//                    }
                    
                    if let error = result["error"] as? [String : AnyObject] {
                        print("An error occurred: \(error)")
                        // todo: dispatch the correct error here
                        callback(nil, KnotSocketError.timeout)
                        return
                    }
                    
                    if let devices = result["devices"] {
                        callback(devices, nil)
                    }
                } else {
                    // todo: dispatch error here: timeout
                    callback(nil, KnotSocketError.timeout)
                }
            })
        }

        genericOperation(operation: operation, callback: callback)
    }
}
