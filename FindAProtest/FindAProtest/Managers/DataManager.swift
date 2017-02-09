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
    
    fileprivate var lastEventFetchTime: Date?
    fileprivate var lastCategoriesFetchTime: Date?
    fileprivate var lastMovementsFetchTime: Date?
    fileprivate var lastOrganizationsFetchTime: Date?
    
    func getEvents(forceNetworkCall: Bool, completion: @escaping (Result<[Event]>) -> Void) {
        if shouldFetchLatestEvents || forceNetworkCall {
            NetworkManager.sharedInstance.getevents(completion: { (result) in
                switch result {
                case .success(let data):
                    do {
                        guard let eventObjects = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [[String:Any]] else {
                            let returnError = FAPError(title: NSLocalizedString("error.parse_error.title", comment: "Parsing Error Title"),
                                                       message: NSLocalizedString("error.parse_error.message", comment: "Could not parse response from server."))
                            DispatchQueue.main.async {
                                completion(.error(returnError))
                            }
                            return
                        }
                        var tempEvents = [Event]()
                        for eventObject in eventObjects {
                            let event = self.parse(eventObject: eventObject)
                            tempEvents.append(event)
                        }
                        self._events = tempEvents
                        self.lastEventFetchTime = Date()
                        DispatchQueue.main.async {
                            completion(.success(self.events))
                        }
                    } catch {
                        let error = error as NSError
                        let returnError = FAPError(title: error.localizedFailureReason ?? "Error",
                                                   message: error.localizedDescription)
                        DispatchQueue.main.async {
                            completion(.error(returnError))
                        }
                    }
                    break
                case .error(let error):
                    DispatchQueue.main.async {
                        completion(.error(error))
                    }
                }
            })
        } else {
            DispatchQueue.main.async {
                completion(.success(self.events))
            }
        }
    }
}


//MARK: Logic for whether or not to make network calls
extension DataManager {
    
    fileprivate var shouldFetchLatestEvents: Bool {
        guard let lastFetchTime = lastEventFetchTime else {
            return true
        }
        return abs(lastFetchTime.timeIntervalSinceNow) >= 600 // 5-minute refresh rate
    }
    
    fileprivate var shouldFetchLatestCategories: Bool {
        guard let lastFetchTime = lastCategoriesFetchTime else {
            return true
        }
        return abs(lastFetchTime.timeIntervalSinceNow) >= 600 // 5-minute refresh rate
    }
    
    fileprivate var shouldFetchLatestMovements: Bool {
        guard let lastFetchTime = lastMovementsFetchTime else {
            return true
        }
        return abs(lastFetchTime.timeIntervalSinceNow) >= 600 // 5-minute refresh rate
    }
    
    fileprivate var shouldFetchLatest: Bool {
        guard let lastFetchTime = lastOrganizationsFetchTime else {
            return true
        }
        return abs(lastFetchTime.timeIntervalSinceNow) >= 600 // 5-minute refresh rate
    }
}

//MARK: Event handling
extension DataManager {
    
    var events: [Event] {
        return _events
    }
    
    func parse(eventObject: [String:Any]) -> Event {
        var event = Event()
        event.id = eventObject["id"] as? Int
        event.movementId = eventObject["movementId"] as? Int
        event.categoryId = eventObject["categoryId"] as? Int
        event.organizationId = eventObject["organizationId"] as? Int
        event.name = eventObject["name"] as? String
        if let eventTimestamp = eventObject["eventTime"] as? Int {
            event.time = Date(timeIntervalSince1970: Double(eventTimestamp))
        }
        if let createdTimestamp = eventObject["createdTime"] as? Int {
            event.created = Date(timeIntervalSince1970: Double(createdTimestamp))
        }
        
        if let updatedTimestamp = eventObject["updatedTime"] as? Int {
            event.updated = Date(timeIntervalSince1970: Double(updatedTimestamp))
        }
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

//MARK: Categories handling
