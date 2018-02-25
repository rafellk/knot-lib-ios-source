//
//  WhiteList.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation
 
// todo: description here
public class SecurityListItem {
    
	public var uuid : String?
	public var rule : String?

    /**
        Returns an array of models based on given dictionary.
     
        Sample usage:
        let securityListItem = SecurityListItem.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

        - parameter array:  NSArray from JSON dictionary.

        - returns: Array of White Instances.
    */
    public class func modelsFromDictionaryArray(array: NSArray) -> [SecurityListItem] {
        var models:[SecurityListItem] = []
        
        for item in array {
            if let item = item as? NSDictionary {
                models.append(SecurityListItem(dictionary: item)!)
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
		rule = dictionary["rule"] as? String
	}
		
    /**
        Returns the dictionary representation for the current instance.
     
        - returns: NSDictionary.
    */
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.uuid, forKey: "uuid")
		dictionary.setValue(self.rule, forKey: "rule")

		return dictionary
	}
}
