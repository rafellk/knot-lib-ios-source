//
//  BaseDeviceData.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class BaseDeviceData {
    
    public var uuid : String?
    public var source : String?
    public var sensorData: SensorData?
    public var timestamp: String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let baseDeviceData = BaseDeviceData.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of BaseDeviceData Instances.
     */
    public class func modelsFromDictionaryArray(array: NSArray) -> [BaseDeviceData] {
        var models:[BaseDeviceData] = []
        
        for item in array {
            if let item = item as? NSDictionary {
                models.append(BaseDeviceData(dictionary: item)!)
            }
        }
        
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let securityListItem = SecurityListItem(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: SecurityListItem Instance.
     */
    required public init?(dictionary: NSDictionary) {
        uuid = dictionary["uuid"] as? String
        
        source = dictionary["source"] as? String
        timestamp = dictionary["timestamp"] as? String
        
        if let sensorData = dictionary["data"] as? NSDictionary {
            self.sensorData = SensorData(dictionary: sensorData)
        }
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(uuid, forKey: "uuid")
        dictionary.setValue(source, forKey: "source")
        dictionary.setValue(timestamp, forKey: "timestamp")
        
        return dictionary
    }
}

