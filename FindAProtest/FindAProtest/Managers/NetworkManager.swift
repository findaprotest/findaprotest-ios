//
//  NetworkManager.swift
//  FindAProtest
//
//  Created by Pratikbhai Patel on 2/3/17.
//  Copyright © 2017 Find a Protest. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(FAPError)
}

struct FAPError: Error {
    var title: String
    var message: String
}

struct Endpoint {
    static let category = "category"
    static let event = "event"
    static let movement = "movement"
    static let organization = "organization"
}

class NetworkManager {
    
    private let networkError = FAPError(title: "Network Error", message: "Could not complete request.")
    static let sharedInstance = NetworkManager()
    
    private let urlSession = URLSession.shared
    
    private init() { } // Don't want any other instance of our class
    
    private let baseURL = "https://findaprotest.herokuapp.com/api/generic/"
    
    func getCategories(completion: @escaping (Result<[Category]>) -> Void) {
        get(urlString: "\(baseURL)\(Endpoint.category)") { (result) in
            switch result {
            case .success(let data):
                print(data)
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    func getevents(completion: @escaping (Result<Data>) -> Void) {
        get(urlString: "\(baseURL)\(Endpoint.event)") { (result) in
            switch result {
            case .success(let data):
                print(data)
                DispatchQueue.main.async {
                    completion(.success(data))
                }
                break
            case .error(let error):
                print(error)
                break
            }
        }
    }
    
    private func get(urlString: String, completion: @escaping (Result<Data>) -> Void) {
        guard let url = URL(string: urlString) else {
            return completion(.error(networkError))
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil,
            let data = data else {
                return
            }
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                return
            }
            completion(.success(data))
        }
        
        dataTask.resume()
        
    }
    
    private func post() {
        
    }
    
    // Probably won't need put in the iOS app unless we're doing an admin app
    private func put() {
        
    }
    
}
