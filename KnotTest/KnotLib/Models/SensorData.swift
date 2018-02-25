//
//  SensorData.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class SensorData {
    
    public var sensorID : Int?
    public var value : Any?
    public var uuid : String?
    public var token : String?
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let securityListItem = SecurityListItem(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: SecurityListItem Instance.
     */
    required public init?(dictionary: NSDictionary) {
        
        uuid = dictionary["uuid"] as? String
        token = dictionary["token"] as? String
        sensorID = dictionary["sensor_id"] as? Int
        value = dictionary["value"]
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(uuid, forKey: "uuid")
        dictionary.setValue(token, forKey: "token")
        dictionary.setValue(sensorID, forKey: "sensor_id")
        dictionary.setValue(value, forKey: "value")
        
        return dictionary
    }
}

