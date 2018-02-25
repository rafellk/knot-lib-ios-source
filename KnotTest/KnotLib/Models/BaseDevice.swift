//
//  BaseDevice.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class BaseDevice {
    
    public var uuid: String?
    public var deviceOwner: DeviceOwner?
	public var online : Bool?
	public var type : String?
	public var ipAddress : String?
	public var discoverWhitelist : [SecurityListItem]?
	public var configureWhitelist : [SecurityListItem]?
	public var geo : Geo?
	public var meshblu : String?
	public var webProtocol : String?
	public var secure : Bool?
	public var onlineSince : String?

    /**
        Returns an array of models based on given dictionary.
     
        Sample usage:
        let baseDevice = BaseDevice.modelsFromDictionaryArray(someDictionaryArrayFromJSON)

        - parameter array:  NSArray from JSON dictionary.

        - returns: Array of Devices Instances.
    */
    public class func modelsFromDictionaryArray(array: NSArray) -> [BaseDevice] {
        var models: [BaseDevice] = []
        
        for item in array {
            if let item = item as? NSDictionary {
                models.append(BaseDevice(dictionary: item)!)
            }
        }
        
        return models
    }

    /**
        Constructs the object based on the given dictionary.
     
        Sample usage:
        let devices = BaseDevice(someDictionaryFromJSON)

        - parameter dictionary:  NSDictionary from JSON.

        - returns: Devices Instance.
    */
	required public init?(dictionary: NSDictionary) {

        uuid = dictionary["uuid"] as? String
        deviceOwner = DeviceOwner(token: dictionary["token"] as? String, owner: dictionary["owner"] as? String)
        
        online = dictionary["online"] as? Bool
        type = dictionary["type"] as? String
		ipAddress = dictionary["ipAddress"] as? String
        
        if let discoverWhiteList = dictionary["discoverWhitelist"] as? [SecurityListItem] {
            self.discoverWhitelist = SecurityListItem.modelsFromDictionaryArray(array: discoverWhiteList as NSArray)
        }
        
        if let configureWhitelist = dictionary["configureWhitelist"] as? [SecurityListItem] {
            self.configureWhitelist = SecurityListItem.modelsFromDictionaryArray(array: configureWhitelist as NSArray)
        }

		if let geo = dictionary["geo"] as? NSDictionary {
            self.geo = Geo(dictionary: geo)
        }
            
        meshblu = dictionary["meshblu"] as? String
		webProtocol = dictionary["protocol"] as? String
		secure = dictionary["secure"] as? Bool
		onlineSince = dictionary["onlineSince"] as? String
	}
		
    /**
        Returns the dictionary representation for the current instance.
     
        - returns: NSDictionary.
    */
	public func dictionaryRepresentation() -> NSDictionary {

		let dictionary = NSMutableDictionary()

		dictionary.setValue(uuid, forKey: "uuid")
		dictionary.setValue(self.online, forKey: "online")
		dictionary.setValue(self.type, forKey: "type")
		dictionary.setValue(deviceOwner?.owner, forKey: "owner")
        dictionary.setValue(deviceOwner?.token, forKey: "token")
		dictionary.setValue(self.ipAddress, forKey: "ipAddress")
		dictionary.setValue(self.geo?.dictionaryRepresentation(), forKey: "geo")
		dictionary.setValue(self.meshblu, forKey: "meshblu")
		dictionary.setValue(self.webProtocol, forKey: "protocol")
		dictionary.setValue(self.secure, forKey: "secure")
		dictionary.setValue(self.onlineSince, forKey: "onlineSince")

		return dictionary
	}
}
