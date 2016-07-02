//
//  LogHandler.swift
//  AIRFD
//
//  Created by Akbarzade on 7/2/16.
//  Copyright © 2016 Akbarzade. All rights reserved.
//

import Foundation
import UIKit

struct LogHandler {
    
    static var CallCount: [String: Int] = [String: Int]()
    
    static func Log(funcName: String = #function){
        if self.CallCount[funcName] == nil {
            self.CallCount[funcName] = 1
        } else if let oldCallCount =  self.CallCount[funcName] {
            self.CallCount[funcName]  = oldCallCount + 1
        }
        if let countTime = CallCount[funcName] {
            print("Counted Time [\(countTime)] Function: \(funcName) Logged.")
        }
    }
}