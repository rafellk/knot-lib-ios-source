//
//  Schema.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class Schema {
    
    public var name : String?
    public var sensorID : String?
    public var typeID : String?
    public var unit : String?
    public var valueType : String?
    
    /**
     Returns an array of models based on given dictionary.
     
     Sample usage:
     let schemaList = Schema.modelsFromDictionaryArray(someDictionaryArrayFromJSON)
     
     - parameter array:  NSArray from JSON dictionary.
     
     - returns: Array of Schema Instances.
     */
    public class func modelsFromDictionaryArray(array: NSArray) -> [Schema] {
        var models: [Schema] = []
        
        for item in array {
            if let item = item as? NSDictionary {
                models.append(Schema(dictionary: item)!)
            }
        }
        
        return models
    }
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let schema = Schema(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: Schema Instance.
     */
    required public init?(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        sensorID = dictionary["sensor_id"] as? String
        typeID = dictionary["type_id"] as? String
        unit = dictionary["unit"] as? String
        valueType = dictionary["value_type"] as? String
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(name, forKey: "name")
        dictionary.setValue(sensorID, forKey: "sensor_id")
        dictionary.setValue(typeID, forKey: "type_id")
        dictionary.setValue(unit, forKey: "unit")
        dictionary.setValue(valueType, forKey: "value_type")
        
        return dictionary
    }
}
