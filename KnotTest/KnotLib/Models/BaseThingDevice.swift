//
//  BaseThingDevice.swift
//  KnotTest
//
//  Created by Rafael Lucena on 2/25/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

class BaseThingDevice: BaseDevice {
    
    var name: String?
    var schema: [Schema]?
    
    required init?(dictionary: NSDictionary) {
        super.init(dictionary: dictionary)
        
        name = dictionary["name"] as? String
        
        if let schemas = dictionary["schema"] as? NSArray {
            self.schema = [Schema]()
            for schema in schemas {
                if let schema = schema as? NSDictionary {
                    self.schema?.append(Schema(dictionary: schema)!)
                }
            }
        }
    }
}
