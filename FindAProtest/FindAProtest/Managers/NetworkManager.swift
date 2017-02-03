//
//  NetworkManager.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/3/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import Foundation

struct Endpoint {
    static let category = "category"
    static let event = "event"
    static let movement = "movement"
    static let organization = "organization"
}

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    
    private init() { } // Don't want any other instance of our class
    
    private let baseURL = "https://findaprotest.herokuapp.com/api/generic/"
    
    private func get() {
        
    }
    
    private func post() {
        
    }
    
    private func put() {
        
    }
    
    
}
