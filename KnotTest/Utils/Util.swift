//
//  Util.swift
//  KnotTest
//
//  Created by aluno on 12/05/18.
//  Copyright © 2018 com.rlmg.knotTest. All rights reserved.
//

import Foundation

class Util {

    private static let CurrentThingToken = "CurrentThingToken"
    private static let DurationToken = "DurationToken"
    
    static var idThing: String? {
        get {
            return UserDefaults.standard.string(forKey: CurrentThingToken)
        }
        
        set(id) {
            UserDefaults.standard.set(id, forKey: CurrentThingToken)
            UserDefaults.standard.synchronize()
        }
    }
    
    static var duration: String? {
        get {
            return UserDefaults.standard.string(forKey: DurationToken)
        }
        
        set(id) {
            UserDefaults.standard.set(id, forKey: DurationToken)
            UserDefaults.standard.synchronize()
        }
    }
}
