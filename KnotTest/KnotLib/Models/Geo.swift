//
//  WhiteList.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class Geo {
    
	public var country : String?
	public var region : Int?
	public var city : String?
	public var ll : Array<Double>?
	public var metro : Int?
	public var zip : Int?

    /**
        Returns an array of models based on given dictionary.
     
        Sample usage:
        let geoList = Geo.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

        - parameter array:  NSArray from JSON dictionary.

        - returns: Array of Geo Instances.
    */
    public class func modelsFromDictionaryArray(array: NSArray) -> [Geo] {
        var models:[Geo] = []
        
        for item in array {
            if let item = item as? NSDictionary {
                models.append(Geo(dictionary: item)!)
            }
        }
        
        return models
    }

    /**
        Constructs the object based on the given dictionary.
     
        Sample usage:
        let geo = Geo(someDictionaryFromJSON)

        - parameter dictionary:  NSDictionary from JSON.

        - returns: Geo Instance.
    */
	required public init?(dictionary: NSDictionary) {

		country = dictionary["country"] as? String
		region = dictionary["region"] as? Int
		city = dictionary["city"] as? String
        
		if let ll = dictionary["ll"] as? NSArray {
            self.ll = [Double]()
            
            for value in ll {
                if let value = value as? Double {
                    self.ll?.append(value)
                }
            }
        }
        
		metro = dictionary["metro"] as? Int
		zip = dictionary["zip"] as? Int
	}
    
    /**
        Returns the dictionary representation for the current instance.
     
        - returns: NSDictionary.
    */
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(self.country, forKey: "country")
		dictionary.setValue(self.region, forKey: "region")
		dictionary.setValue(self.city, forKey: "city")
		dictionary.setValue(self.metro, forKey: "metro")
		dictionary.setValue(self.zip, forKey: "zip")
        dictionary.setValue(ll, forKey: "ll")

		return dictionary
	}
}
