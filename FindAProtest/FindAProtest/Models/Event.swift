//
//  Event.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/3/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import Foundation

struct Event {
    var id: Int?
    var movementId: Int?
    var categoryId: Int?
    var organizationId: Int?
    var name: String?
    var time: Date?
    var created: Date?
    var updated: Date?
    var city: String?
    var state: String?
    var location: String?
    var description: String?
    var tags: [String]?
    var link: URL?
    var estimatedSize: Int?
    var actualSize: Int?
}
