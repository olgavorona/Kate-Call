//
//  NetworkService.swift
//  TinderCall
//
//  Created by Olga Vorona on 30/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//
import Reachability

class NetworkService {
    
    func isReachable() -> Bool {
        let r = Reachability()
       return r.isReachable()
    }
}
