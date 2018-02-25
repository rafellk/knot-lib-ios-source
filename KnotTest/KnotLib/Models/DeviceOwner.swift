//
//  WhiteList.swift
//  KnotTest
//
//  Created by Rafael Lucena on 1/19/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

// todo: description here
public class DeviceOwner {
    
    public var token : String?
    public var owner : String?
    
    /**
     Constructs the object based on the given dictionary.
     
     Sample usage:
     let deviceOwner = DeviceOwner(someDictionaryFromJSON)
     
     - parameter dictionary:  NSDictionary from JSON.
     
     - returns: DeviceOwner Instance.
     */
    required public init?(token: String?, owner: String?) {
        self.token = token
        self.owner = owner
    }
    
    /**
     Returns the dictionary representation for the current instance.
     
     - returns: NSDictionary.
     */
    public func dictionaryRepresentation() -> NSDictionary {
        
        let dictionary = NSMutableDictionary()
        
        dictionary.setValue(token, forKey: "token")
        dictionary.setValue(owner, forKey: "owner")
        
        return dictionary
    }
}

