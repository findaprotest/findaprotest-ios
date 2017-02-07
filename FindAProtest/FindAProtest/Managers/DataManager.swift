//
//  DataManager.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/3/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import Foundation

class DataManager {
    
    static let sharedInstance = DataManager()
    
    private init() { }
    
    fileprivate var _events = [Event]()
    fileprivate var _categories = [Category]()
    fileprivate var _movements = [Movement]()
    fileprivate var _organizations = [Organization]()
    
    private var shouldGetEvents = true
    
    func getEvents(completion: @escaping (Result<[Event]>) -> Void) {
        if shouldGetEvents {
            NetworkManager.sharedInstance.getevents(completion: { (result) in
                switch result {
                case .success(let data):
                    do {
                        guard let eventObjects = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String:Any]] else {
                            let returnError = FAPError(title: "Parse Error", message: "Could not response from server")
                            completion(.error(returnError))
                            return
                        }
                        var tempEvents = [Event]()
                        for eventObject in eventObjects {
                            let event = self.parse(eventObject: eventObject)
                            tempEvents.append(event)
                        }
                        self._events = tempEvents
                        completion(.success(self.events))
                    } catch {
                        let error = error as NSError
                        let returnError = FAPError(title: error.localizedFailureReason ?? "Error",
                                                   message: error.localizedDescription)
                        completion(.error(returnError))
                        
                    }
                    break
                case .error(let error):
                    completion(.error(error))
                }
            })
        } else {
            completion(.success(events))
        }
    }
}

// Event stuff
extension DataManager {
    
    var events: [Event] {
        return _events
    }
    
    func parse(eventObject: [String:Any]) -> Event {
        dump(eventObject)
        var event = Event()
        event.id = eventObject["id"] as? Int
        event.movementId = eventObject["movementId"] as? Int
        event.categoryId = eventObject["categoryId"] as? Int
        event.organizationId = eventObject["organizationId"] as? Int
        event.name = eventObject["name"] as? String
        
        // ************************************************************************************************//
        //TODO: Make sure to fix this to get proper times if API is updated to use numbes
        if let eventTimestampString = eventObject["eventTime"] as? String,
            let eventTimestamp = Int(eventTimestampString) {
            event.time = Date(timeIntervalSince1970: Double(eventTimestamp))
        }
        if let createdTimestampString = eventObject["createdTime"] as? String,
            let createdTimestamp = Int(createdTimestampString) {
            event.created = Date(timeIntervalSince1970: Double(createdTimestamp))
        }
        
        if let updatedTimestampString = eventObject["updatedTime"] as? String,
            let updatedTimestamp = Int(updatedTimestampString) {
            event.updated = Date(timeIntervalSince1970: Double(updatedTimestamp))
        }
        // ************************************************************************************************//
        event.city = eventObject["city"] as? String
        event.state = eventObject["state"] as? String
        event.location = eventObject["location"] as? String
        event.description = eventObject["description"] as? String
        if let tags = eventObject["tags"] as? [String] {
            event.tags = tags
        }
        if let urlString = eventObject["link"] as? String {
            event.link = URL(string: urlString)
        }
        event.estimatedSize = eventObject["estimatedSize"] as? Int
        event.actualSize = eventObject["actualSize"] as? Int
        
        return event
    }
}

// Categories Stuff
